expect_ptype_equal <- function(actual, expected, exact = TRUE) {
  if (!exact) {
    # Keep only the columns from each that are in the other
    shared_names <- intersect(names(actual), names(expected))
    actual <- actual[, shared_names]
    expected <- expected[, shared_names]
  }
  expect_equal(vctrs::vec_ptype(actual), vctrs::vec_ptype(expected))
}

skip_if_connect_older_than <- function(client, version) {
  if (numeric_version(safe_server_version(client)) < numeric_version(version)) {
    skip(paste("Requires Connect >=", version))
  }
}

deploy_example <- function(connect, name, ...) {
  example_dir <- rprojroot::find_package_root_file(
    "tests",
    "testthat",
    "examples",
    name
  )
  bundle_file <- fs::file_temp(pattern = name, ext = ".tar.gz")
  bund <- bundle_dir(path = example_dir, filename = bundle_file)

  tsk <- deploy(
    connect = connect,
    bundle = bund,
    name = name,
    ...
  )

  guid <- tsk$content$guid
  content <- content_item(tsk$connect, guid)

  # TODO: a smarter, noninteractive wait...
  suppressMessages(poll_task(tsk))
  content
}
