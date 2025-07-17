# Setup ----------------------------------------------------

collab_guid <- NULL
viewer_guid <- NULL

# deploy content
cont1_title <- "Test Content 1"
cont1_content <- deploy_example(test_conn_1, "static", title = cont1_title)
cont1_guid <- cont1_content$content$guid


# Metadata Tests ----------------------------------------------------

test_that("content_item works", {
  cont1_tmp <- test_conn_1 %>% content_item(guid = cont1_guid)

  expect_true(validate_R6_class(cont1_tmp, "Content"))
  expect_equal(cont1_tmp$get_content()$guid, cont1_guid)
})

test_that("content_title works in a simple example", {
  test_title <- content_title(test_conn_1, cont1_guid)
  expect_identical(test_title, cont1_title)
})

test_that("content_title handles missing content gracefully", {
  null_title <- content_title(test_conn_1, "not_a_real_guid")
  expect_identical(null_title, "Unknown Content")

  null_title_custom <- content_title(
    test_conn_1,
    "not_a_real_guid",
    "other-default"
  )
  expect_identical(null_title_custom, "other-default")
})

test_that("content_title handles NULL titles gracefully", {
  c2_name <- uuid::UUIDgenerate()
  bnd <- bundle_static(
    path = rprojroot::find_package_root_file(
      "tests/testthat/examples/static/test.png"
    )
  )
  c2 <- deploy(connect = test_conn_1, bundle = bnd, name = c2_name, title = NA)
  expect_null(c2$get_content()$title)
  null_title <- content_title(test_conn_1, c2$get_content()$guid, "Test Title")
  expect_identical(null_title, "Test Title")
})

test_that("content_update_owner works", {
  bnd <- bundle_static(
    path = rprojroot::find_package_root_file(
      "tests/testthat/examples/static/test.png"
    )
  )
  myc <- deploy(test_conn_1, bnd)

  new_user <- test_conn_1$users_create(
    username = glue::glue("test_admin_{create_random_name()}"),
    email = "example@example.com",
    user_role = "administrator",
    user_must_set_password = TRUE
  )

  expect_equal(myc$get_content_remote()$owner_guid, test_conn_1$me()$guid)

  res <- content_update_owner(myc, new_user$guid)

  expect_equal(
    myc$get_content_remote()$owner_guid,
    new_user$guid
  )

  # permissions do not remain
  expect_null(get_user_permission(myc, test_conn_1$me()$guid))

  # switch back (as an admin)
  res2 <- content_update_owner(myc, test_conn_1$me()$guid)

  expect_equal(myc$get_content_remote()$owner_guid, test_conn_1$me()$guid)

  # permissions do not remain
  expect_null(get_user_permission(myc, new_user$guid))

  # viewer cannot be made an owner
  viewer_user <- test_conn_1$users_create(
    username = glue::glue("test_viewer_{create_random_name()}"),
    email = "viewer@example.com",
    user_role = "viewer",
    user_must_set_password = TRUE
  )

  expect_error(
    expect_message(
      content_update_owner(myc, viewer_user$guid),
      "permission to publish"
    ),
    "403"
  )
})

test_that("content_update_access_type works", {
  tar_path <- rprojroot::find_package_root_file(
    "tests/testthat/examples/static.tar.gz"
  )
  bund <- bundle_path(path = tar_path)

  tsk <- deploy(connect = test_conn_1, bundle = bund)

  # returns as expected
  tsk <- content_update_access_type(tsk, "all")
  expect_equal(tsk$get_content()$access_type, "all")

  # modifies the R6 object in place
  content_update_access_type(tsk, "logged_in")
  expect_equal(tsk$get_content()$access_type, "logged_in")

  # works twice
  content_update_access_type(tsk, "acl")
  content_update_access_type(tsk, "acl")
  expect_equal(tsk$get_content()$access_type, "acl")

  expect_error(content_update_access_type(tsk), "one of")
})

test_that("content_update works", {
  tar_path <- rprojroot::find_package_root_file(
    "tests/testthat/examples/static.tar.gz"
  )
  bund <- bundle_path(path = tar_path)

  tsk <- deploy(connect = test_conn_1, bundle = bund)

  content_update(tsk, title = "test content_update")
  expect_equal(tsk$get_content()$title, "test content_update")

  # should not change or error with empty input
  expect_equal(content_update(tsk)$get_content()$title, "test content_update")

  expect_equal(
    content_update(tsk, title = "test content_update2")$get_content()$title,
    "test content_update2"
  )
})

test_that("content_delete works", {
  tar_path <- rprojroot::find_package_root_file(
    "tests/testthat/examples/static.tar.gz"
  )
  bund <- bundle_path(path = tar_path)

  tsk <- deploy(connect = test_conn_1, bundle = bund)

  expect_message(res <- content_delete(tsk, force = TRUE), "Deleting content")
  expect_true(validate_R6_class(res, "Content"))

  expect_error(res$get_content_remote(), "404")
})

test_that("content_delete prompts and errors", {
  skip("not sure how to test this")
})

# Bundles ---------------------------------------------------

test_that("get_bundles and delete_bundle work", {
  bnd_name <- create_random_name()
  bnd <- bundle_static(
    path = rprojroot::find_package_root_file(
      "tests/testthat/examples/static/test.png"
    )
  )

  bc1 <- deploy(test_conn_1, bnd, bnd_name)
  bc1 <- deploy(test_conn_1, bnd, bnd_name)
  bc1 <- deploy(test_conn_1, bnd, bnd_name)

  bnd_dat <- get_bundles(bc1)
  expect_equal(nrow(bnd_dat), 3)
  expect_s3_class(bnd_dat, "tbl_df")

  not_active_bundles <- bnd_dat[!bnd_dat$active, ]

  bnd_del <- delete_bundle(bc1, not_active_bundles[["id"]][[1]])
  expect_true(validate_R6_class(bnd_del, "Content"))

  bnd_dat2 <- get_bundles(bc1)
  expect_equal(nrow(bnd_dat2), 2)
})

# Permissions ---------------------------------------

test_that("returns owner permission", {
  tar_path <- rprojroot::find_package_root_file(
    "tests/testthat/examples/static.tar.gz"
  )
  bund <- bundle_path(path = tar_path)
  tsk <- deploy(connect = test_conn_1, bundle = bund)
  my_guid <- test_conn_1$GET("me")$guid

  prm <- get_content_permissions(tsk)
  expect_length(prm[["id"]], 1)
  expect_equal(prm[["principal_guid"]], my_guid)

  my_prm <- get_user_permission(tsk, my_guid)
  expect_equal(my_prm$role, "owner")

  # NOTE: this NA shows that owner was injected
  expect_equal(my_prm$id, NA_character_)

  my_prm <- get_my_permission(tsk)
  expect_equal(my_prm$role, "owner")

  # add_owner = FALSE gives the previous behavior
  expect_length(get_my_permission(tsk, add_owner = FALSE), 0)
})

test_that("add a collaborator works", {
  # create a user
  collab <- test_conn_1$users_create(
    username = glue::glue("test_collab{create_random_name()}"),
    email = "collab@example.com",
    user_must_set_password = TRUE,
    user_role = "publisher"
  )
  collab_guid <<- collab$guid

  # no permission at first
  expect_null(get_user_permission(cont1_content, collab_guid))

  # add a collaborator
  invisible(content_add_user(cont1_content, collab_guid, "owner"))

  expect_equal(get_user_permission(cont1_content, collab_guid)$role, "owner")
})

test_that("add collaborator twice works", {
  # add a collaborator
  invisible(content_add_user(cont1_content, collab_guid, "owner"))
  invisible(content_add_user(cont1_content, collab_guid, "owner"))

  # get acl
  acls <- get_content_permissions(cont1_content)

  which_match <- purrr::map2_lgl(
    acls$principal_guid,
    acls$role,
    function(.x, .y) {
      .x == collab_guid && .y == "owner"
    }
  )
  expect_true(any(which_match))
  expect_equal(sum(which_match), 1)
})

test_that("add a viewer works", {
  # create a user
  view_user <- test_conn_1$users_create(
    username = glue::glue("test_viewer{create_random_name()}"),
    email = "viewer@example.com",
    user_must_set_password = TRUE,
    user_role = "viewer"
  )
  viewer_guid <<- view_user$guid

  # no permission at first
  expect_null(get_user_permission(cont1_content, viewer_guid))

  # add a viewer
  invisible(content_add_user(cont1_content, viewer_guid, "viewer"))

  # get acl
  acls <- get_content_permissions(cont1_content)

  which_match <- purrr::map2_lgl(
    acls$principal_guid,
    acls$role,
    function(.x, .y) {
      .x == viewer_guid && .y == "viewer"
    }
  )
  expect_true(any(which_match))
  expect_equal(sum(which_match), 1)
})

test_that("add a viewer twice works", {
  # add a viewer
  invisible(content_add_user(cont1_content, viewer_guid, "viewer"))
  invisible(content_add_user(cont1_content, viewer_guid, "viewer"))

  # get acl
  acls <- get_content_permissions(cont1_content)

  which_match <- purrr::map2_lgl(
    acls$principal_guid,
    acls$role,
    function(.x, .y) {
      .x == viewer_guid && .y == "viewer"
    }
  )
  expect_true(any(which_match))
  expect_equal(sum(which_match), 1)
})

test_that("remove a collaborator works", {
  # remove a collaborator
  invisible(content_delete_user(cont1_content, collab_guid))

  # get acl
  acls <- get_content_permissions(cont1_content)

  which_match <- purrr::map2_lgl(
    acls$principal_guid,
    acls$role,
    function(.x, .y) {
      .x == collab_guid && .y == "owner"
    }
  )
  expect_false(any(which_match))
})

test_that("remove a collaborator twice works", {
  # remove a collaborator
  invisible(content_delete_user(cont1_content, collab_guid))
  invisible(content_delete_user(cont1_content, collab_guid))

  # get acl
  acls <- get_content_permissions(cont1_content)

  which_match <- purrr::map2_lgl(
    acls$principal_guid,
    acls$role,
    function(.x, .y) {
      .x == collab_guid && .y == "owner"
    }
  )
  expect_false(any(which_match))
})
