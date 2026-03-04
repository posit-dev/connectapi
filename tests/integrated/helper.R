expect_datetime_cols <- function(actual, datetime_cols) {
  for (col in intersect(datetime_cols, names(actual))) {
    expect_s3_class(actual[[col]], "POSIXct", info = paste("Column:", col))
  }
}

skip_if_connect_older_than <- function(client, version) {
  current <- numeric_version(simplify_version(safe_server_version(client)))
  if (current < numeric_version(version)) {
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
