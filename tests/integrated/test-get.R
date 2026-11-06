cont1_name <- uuid::UUIDgenerate()
cont1_title <- "Test Content 1"
cont1_guid <- NULL
cont1_bundle <- NULL
cont1_content <- NULL

# get --------------------------------------------

test_that("get_users works", {
  users <- get_users(client)

  expect_s3_class(users, c("tbl_df", "tbl", "data.frame"))

  expect_true("guid" %in% names(users))
  expect_true("email" %in% names(users))
  expect_true("username" %in% names(users))
  expect_s3_class(users$created_time, "POSIXct")

  # Other tests create users, so specifying the exact number here is conditional
  # on the contents of other tests and the order that tests run in.
  admins <- get_users(client, user_role = "administrator")
  expect_true(nrow(admins) > 0)

  licensed <- get_users(client, account_status = "licensed")
  expect_true(nrow(licensed) > 0)
})

test_that("get_groups works", {
  # Create a group so we have data to assert against (test-get.R runs before
  # test-groups.R alphabetically).
  client$groups_create(name = paste0("test-get-groups-", uuid::UUIDgenerate()))

  groups_list <- get_groups(client)
  expect_s3_class(groups_list, c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(groups_list) > 0)
  expect_true("guid" %in% names(groups_list))
  expect_true("name" %in% names(groups_list))
})

test_that("get_content works", {
  scoped_experimental_silence()
  content_list <- get_content(client)
  expect_s3_class(content_list, c("tbl_df", "tbl", "data.frame"))
  expect_true("guid" %in% names(content_list))
  expect_true("name" %in% names(content_list))
  expect_s3_class(content_list$created_time, "POSIXct")
})

test_that("get_usage_shiny works", {
  shiny_usage <- get_usage_shiny(client)
  expect_s3_class(shiny_usage, c("tbl_df", "tbl", "data.frame"))
  # No shiny apps are deployed in integration tests, so this may be empty.
  if (nrow(shiny_usage) > 0) {
    expect_true("content_guid" %in% names(shiny_usage))
    expect_s3_class(shiny_usage$started, "POSIXct")
  }
})

test_that("get_usage_static works", {
  content_visits <- get_usage_static(client)
  expect_s3_class(content_visits, c("tbl_df", "tbl", "data.frame"))
  expect_true("content_guid" %in% names(content_visits))
  expect_s3_class(content_visits$time, "POSIXct")
})

test_that("get_audit_logs works", {
  audit_list <- get_audit_logs(client)
  expect_s3_class(audit_list, c("tbl_df", "tbl", "data.frame"))

  # This is different on older versions, not sure it's worth worrying about how
  skip_if_connect_older_than(client, "2022.09.0")
  expect_true("id" %in% names(audit_list))
  expect_s3_class(audit_list$time, "POSIXct")
})

# Deploy a dependency-free Python API and keep a process for it running, so
# the process endpoints have something to return.
deploy_running_python_api <- function(client) {
  py <- get_runtimes(client, runtimes = "python")
  py_version <- py$version[[nrow(py)]]

  dir <- fs::dir_create(fs::file_temp("python-api"))
  writeLines(
    c(
      "def app(environ, start_response):",
      "    start_response('200 OK', [('Content-Type', 'text/plain')])",
      "    return [b'ok']"
    ),
    fs::path(dir, "app.py")
  )
  writeLines(character(), fs::path(dir, "requirements.txt"))
  jsonlite::write_json(
    list(
      version = 1,
      metadata = list(appmode = "python-api", entrypoint = "app:app"),
      python = list(
        version = py_version,
        package_manager = list(name = "pip", package_file = "requirements.txt")
      ),
      files = list(
        app.py = list(checksum = unname(tools::md5sum(fs::path(dir, "app.py")))),
        requirements.txt = list(
          checksum = unname(tools::md5sum(fs::path(dir, "requirements.txt")))
        )
      )
    ),
    fs::path(dir, "manifest.json"),
    auto_unbox = TRUE
  )

  bnd <- bundle_dir(dir, filename = fs::file_temp(ext = ".tar.gz"))
  tsk <- deploy(client, bnd, name = create_random_name())
  suppressMessages(poll_task(tsk))
  content <- content_item(client, tsk$content$guid)
  content_update(content, min_processes = 1)

  # Visit the content too, in case min_processes is not applied right away.
  httr::GET(content$get_url(), client$add_auth())
  content
}

test_that("get_processes and get_procs return running processes", {
  content <- deploy_running_python_api(client)
  guid <- content$content$guid

  procs <- NULL
  for (i in seq_len(60)) {
    procs <- get_processes(client, content_guid = guid)
    if (nrow(procs) > 0 && !is.na(procs$heartbeat[[1]])) break
    Sys.sleep(2)
  }

  expect_identical(names(procs)[1:13], c(
    "content_guid", "content_name", "content_url", "run_as", "type", "pid",
    "hostname", "job_key", "image", "start_time", "heartbeat", "cpu_current",
    "ram"
  ))
  expect_column_types(procs, list(
    content_guid = "character",
    content_name = "character",
    content_url = "character",
    run_as = "character",
    type = "character",
    pid = "integer",
    hostname = "character",
    job_key = "character",
    image = "character",
    start_time = "POSIXct",
    heartbeat = "POSIXct",
    cpu_current = "numeric",
    ram = "fs_bytes"
  ), exact = FALSE)

  expect_gte(nrow(procs), 1)
  proc <- procs[1, ]
  expect_identical(proc$content_guid, guid)
  expect_identical(proc$content_name, content$content$name)
  expect_identical(proc$type, "run_python_api")
  expect_false(is.na(proc$pid))
  expect_false(is.na(proc$hostname))
  expect_false(is.na(proc$heartbeat))
  expect_gt(as.numeric(proc$ram), 0)

  # Unfiltered results include it.
  all_procs <- get_processes(client)
  expect_true(proc$job_key %in% all_procs$job_key)

  # The filters narrow the results, and are ANDed.
  me <- client$me()
  expect_true(
    proc$job_key %in% get_processes(client, owner_guid = me$guid)$job_key
  )
  expect_true(
    proc$job_key %in% get_processes(client, hostname = proc$hostname)$job_key
  )
  expect_equal(
    nrow(get_processes(client, content_guid = guid, hostname = "no-such-host")),
    0
  )

  # get_procs() is deprecated but returns the same process, with the server's
  # pid rather than the row index (#532).
  lifecycle::expect_deprecated(old <- get_procs(client))
  old_proc <- old[old$job_key == proc$job_key, ]
  expect_equal(nrow(old_proc), 1)
  expect_identical(old_proc$app_guid, guid)
  expect_equal(as.integer(old_proc$pid), proc$pid)
  expect_s3_class(old_proc$start_time, "POSIXct")

  content_update(content, min_processes = 0)
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
