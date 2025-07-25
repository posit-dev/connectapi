parent_tag_name <- uuid::UUIDgenerate(use.time = TRUE)
child_tag_name <- uuid::UUIDgenerate(use.time = TRUE)

parent_tag <- NULL
child_tag <- NULL

content_name <- uuid::UUIDgenerate(use.time = TRUE)

tag_content <- NULL

check_tag_exists <- function(con, id) {
  res <- tryCatch(suppressMessages(con$tag(id)), error = function(e) {
    return(e)
  })
  if (is.numeric(res[["id"]])) {
    TRUE
  } else if (regexpr("simpleError", res) && regexpr("(404) Not Found", res)) {
    FALSE
  } else {
    stop("error retrieving tag")
  }
}

# Tests ---------------------------------------

test_that("create tags works", {
  parent_tag <<- test_conn_1$tag_create(parent_tag_name)
  child_tag <<- test_conn_1$tag_create(child_tag_name, parent_tag$id)

  expect_identical(parent_tag$name, parent_tag_name)
  expect_identical(child_tag$name, child_tag_name)
  expect_identical(child_tag$parent_id, parent_tag$id)

  # tag_id lookup works
  test_conn_1$get_tags(TRUE)
  expect_equal(child_tag$id, test_conn_1$get_tag_id(child_tag_name))
})

## Test high level functions --------------------------------------------------

test_that("get_tags works", {
  atags <- get_tags(test_conn_1)
  expect_s3_class(atags, "connect_tag_tree")
})

test_that("create_tag and delete_tag works", {
  ptag_1 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_1 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_2 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_3 <- uuid::UUIDgenerate(use.time = TRUE)

  capture.output(res <- create_tag(test_conn_1, ptag_1))
  expect_true(validate_R6_class(res, "Connect"))

  tags <- get_tags(test_conn_1)
  capture.output(create_tag(test_conn_1, ctag_1, tags[[ptag_1]]))

  tags <- get_tags(test_conn_1)
  capture.output(create_tag(test_conn_1, ctag_2, tags[[ptag_1]][[ctag_1]]))

  tags <- get_tags(test_conn_1)
  capture.output(create_tag(
    test_conn_1,
    ctag_3,
    tags[[ptag_1]][[ctag_1]][[ctag_2]]
  ))

  tags <- get_tags(test_conn_1)

  delete_tag(test_conn_1, tags[[ptag_1]][[ctag_1]][[ctag_2]][[ctag_3]])
  expect_false(check_tag_exists(
    test_conn_1,
    tags[[ptag_1]][[ctag_1]][[ctag_2]][[ctag_3]][["id"]]
  ))

  delete_tag(test_conn_1, tags[[ptag_1]][[ctag_1]][[ctag_2]])
  expect_false(check_tag_exists(
    test_conn_1,
    tags[[ptag_1]][[ctag_1]][[ctag_2]][["id"]]
  ))

  delete_tag(test_conn_1, tags[[ptag_1]][[ctag_1]])
  expect_false(check_tag_exists(test_conn_1, tags[[ptag_1]][[ctag_1]][["id"]]))

  res <- delete_tag(test_conn_1, tags[[ptag_1]])
  expect_false(check_tag_exists(test_conn_1, tags[[ptag_1]][["id"]]))

  expect_true(validate_R6_class(res, "Connect"))
})

test_that("delete_tag errs for whole tree", {
  alltags <- get_tags(test_conn_1)

  expect_error(
    delete_tag(test_conn_1, alltags),
    "entire tag tree"
  )
})

test_that("con$tag with id returns just one record", {
  ptag_1 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_1 <- uuid::UUIDgenerate(use.time = TRUE)
  capture.output(a1 <- create_tag_tree(test_conn_1, ptag_1, ctag_1))

  tags1 <- get_tags(test_conn_1)
  res <- test_conn_1$tag(tags1[[ptag_1]][[ctag_1]][["id"]])
  expect_equal(
    names(res),
    c("id", "name", "parent_id", "created_time", "updated_time")
  )
})

test_that("create_tag_tree works", {
  ptag_1 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_1 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_2 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_3 <- uuid::UUIDgenerate(use.time = TRUE)

  capture.output(a1 <- create_tag_tree(test_conn_1, ptag_1, ctag_1))
  expect_true(validate_R6_class(a1, "Connect"))

  tags1 <- get_tags(test_conn_1)

  capture.output(
    a2 <- create_tag_tree(test_conn_1, ptag_1, ctag_1, ctag_2, ctag_3)
  )
  expect_true(validate_R6_class(a2, "Connect"))

  tags2 <- get_tags(test_conn_1)

  expect_identical(tags1[[ptag_1]][["id"]], tags2[[ptag_1]][["id"]])

  delete_tag(test_conn_1, tags2[[ptag_1]])
  expect_error(
    suppressMessages(test_conn_1$tag(tags2[[ptag_1]][["id"]])),
    "Not Found"
  )
})


test_that("get_content_tags and set_content_tags works", {
  ptag_1 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_1_1 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_1_2 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_2_1 <- uuid::UUIDgenerate(use.time = TRUE)

  app1 <- deploy(
    test_conn_1,
    bundle_dir(rprojroot::find_package_root_file(
      "tests",
      "testthat",
      "examples",
      "static"
    ))
  )

  capture.output(
    tmp1 <- create_tag_tree(test_conn_1, ptag_1, ctag_1_1, ctag_1_2)
  )
  capture.output(tmp2 <- create_tag_tree(test_conn_1, ptag_1, ctag_2_1))

  expect_true(validate_R6_class(tmp1, "Connect"))
  expect_true(validate_R6_class(tmp2, "Connect"))

  ct <- get_content_tags(app1)
  expect_length(ct, 0)

  all_tags <- get_tags(test_conn_1)

  c1o <- capture.output(
    c1 <- set_content_tags(
      app1,
      all_tags[[ptag_1]][[ctag_1_1]][[ctag_1_2]]
    )
  )
  expect_identical(c1, app1)
  expect_length(get_content_tags(app1), 1)

  c2o <- capture.output(
    c2 <- set_content_tags(
      app1,
      all_tags[[ptag_1]][[ctag_1_1]][[ctag_1_2]],
      all_tags[[ptag_1]][[ctag_2_1]]
    )
  )
  expect_identical(c2, app1)
  expect_length(get_content_tags(app1)[[ptag_1]], 4) # 2 tags, id, name

  # TODO: use newer way to delete tags
  app1$tag_delete(get_content_tags(app1)[[ptag_1]][["id"]])
  expect_length(get_content_tags(app1), 0)
})

test_that("set_content_tag_tree works", {
  ptag_1 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_1_1 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_1_2 <- uuid::UUIDgenerate(use.time = TRUE)
  ctag_2_1 <- uuid::UUIDgenerate(use.time = TRUE)

  app1 <- deploy(
    test_conn_1,
    bundle_dir(rprojroot::find_package_root_file(
      "tests",
      "testthat",
      "examples",
      "static"
    ))
  )

  capture.output(
    tmp1 <- create_tag_tree(test_conn_1, ptag_1, ctag_1_1, ctag_1_2)
  )
  capture.output(tmp2 <- create_tag_tree(test_conn_1, ptag_1, ctag_2_1))

  expect_true(validate_R6_class(tmp1, "Connect"))
  expect_true(validate_R6_class(tmp2, "Connect"))

  ct <- get_content_tags(app1)
  expect_length(ct, 0)

  c1o <- capture.output(
    c1 <- set_content_tag_tree(
      app1,
      ptag_1,
      ctag_1_1,
      ctag_1_2
    )
  )
  expect_identical(c1, app1)
  expect_length(get_content_tags(app1), 1)

  c2o <- capture.output(
    c2 <- set_content_tag_tree(
      app1,
      ptag_1,
      ctag_2_1
    )
  )
  expect_identical(c2, app1)
  expect_length(get_content_tags(app1)[[ptag_1]], 4) # 2 tags, id, name

  # TODO: use newer way to delete tags
  app1$tag_delete(get_content_tags(app1)[[ptag_1]][["id"]])
  expect_length(get_content_tags(app1), 0)
})
