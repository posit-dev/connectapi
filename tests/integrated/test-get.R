cont1_name <- uuid::UUIDgenerate()
cont1_title <- "Test Content 1"
cont1_guid <- NULL
cont1_bundle <- NULL
cont1_content <- NULL

# get --------------------------------------------

test_that("get_users works", {
  users <- get_users(client)

  expect_s3_class(users, c("tbl_df", "tbl", "data.frame"))
  expect_equal(
    purrr::map_chr(vctrs::vec_ptype(users), typeof),
    purrr::map_chr(vctrs::vec_ptype(connectapi_ptypes$users), typeof)
  )

  # Other tests create users, so specifying the exact number here is conditional
  # on the contents of other tests and the order that tests run in.
  admins <- get_users(client, user_role = "administrator")
  expect_true(nrow(admins) > 0)

  licensed <- get_users(client, account_status = "licensed")
  expect_true(nrow(licensed) > 0)
})

test_that("get_groups works", {
  groups_list <- get_groups(client)
  expect_s3_class(groups_list, c("tbl_df", "tbl", "data.frame"))

  expect_ptype_equal(groups_list, connectapi_ptypes$groups)
})

test_that("get_content works", {
  scoped_experimental_silence()
  content_list <- get_content(client)
  expect_s3_class(content_list, c("tbl_df", "tbl", "data.frame"))

  # various attributes have been added over the years, so exact match
  # doesn't work against all versions of Connect
  expect_ptype_equal(content_list, connectapi_ptypes$content, exact = FALSE)
})

test_that("get_usage_shiny works", {
  shiny_usage <- get_usage_shiny(client)
  expect_s3_class(shiny_usage, c("tbl_df", "tbl", "data.frame"))

  expect_ptype_equal(shiny_usage, connectapi_ptypes$usage_shiny)
})

test_that("get_usage_static works", {
  content_visits <- get_usage_static(client)
  expect_s3_class(content_visits, c("tbl_df", "tbl", "data.frame"))

  # path was added to usage_static in 2024
  expect_ptype_equal(
    content_visits,
    connectapi_ptypes$usage_static,
    exact = FALSE
  )
})

test_that("get_audit_logs works", {
  audit_list <- get_audit_logs(client)
  expect_s3_class(audit_list, c("tbl_df", "tbl", "data.frame"))

  # This is different on older versions, not sure it's worth worrying about how
  skip_if_connect_older_than(client, "2022.09.0")
  expect_ptype_equal(audit_list, connectapi_ptypes$audit_logs)
})

test_that("get_procs works", {
  scoped_experimental_silence()
  proc_data <- get_procs(client)

  # TODO: This is not a great test, since no processes are running
  # we could always start a content restoration...
  expect_s3_class(proc_data, "tbl_df")
  expect_ptype_equal(proc_data, connectapi_ptypes$procs)
})

# experimental --------------------------------------------

test_that("content_list_with_permissions works", {
  scoped_experimental_silence()

  rlang::with_options(
    progress_enabled = FALSE,
    cl <- content_list_with_permissions(client)
  )

  expect_true("permission" %in% names(cl))
  expect_s3_class(cl, "tbl_df")
})

test_that("content_list_with_permissions predicate works", {
  scoped_experimental_silence()

  # deploy a static app so we know it is not empty
  bnd <- bundle_static(
    path = rprojroot::find_package_root_file(
      "tests/testthat/examples/static/test.png"
    )
  )
  uniq_id <- uuid::UUIDgenerate()
  deployed <- deploy(client, bnd, uniq_id)

  rlang::with_options(
    progress_enabled = FALSE,
    cl <- content_list_with_permissions(
      client,
      .p = ~ .x$guid == deployed$content$guid
    )
  )

  expect_true("permission" %in% names(cl))
  expect_s3_class(cl, "tbl_df")
  expect_equal(nrow(cl), 1)
})

test_that("content_list_guid_has_access works", {
  scoped_experimental_silence()

  # deploy a static app so we know it is not empty
  bnd <- bundle_static(
    path = rprojroot::find_package_root_file(
      "tests/testthat/examples/static/test.png"
    )
  )
  uniq_id <- uuid::UUIDgenerate()
  deployed <- deploy(client, bnd, uniq_id)

  rlang::with_options(
    progress_enabled = FALSE,
    cl <- content_list_with_permissions(client)
  )

  my_guid <- client$me()$guid
  filt <- content_list_guid_has_access(cl, my_guid)
  expect_true("permission" %in% names(filt))
  expect_true(nrow(filt) <= nrow(cl))

  expect_true(nrow(filt) > 0)
  expect_true(deployed$content$guid %in% filt$guid)
})

test_that("content_list_by_tag works", {
  skip("not yet tested")
})
