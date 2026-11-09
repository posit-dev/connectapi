# Deploy a dependency-free Python API and keep a process for it running, so
# the process endpoints have something to return.
#
# This needs content that keeps a process running. The other content these
# tests deploy is static or rendered (R Markdown), so no process stays up after
# deploying it. The Shiny example (used by test-run-as.R) pins R 3.6.3, which
# newer images don't have, and any R content that keeps a process running
# (Shiny, Plumber) depends on packages that Connect would have to install on
# deploy. A WSGI app with an empty requirements.txt installs nothing.
deploy_running_python_api <- function(client) {
  py <- get_runtimes(client, runtimes = "python")
  if (is.null(py) || nrow(py) == 0) {
    skip("No Python installation available on this Connect server")
  }
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
  # Stop the process even if an expectation below fails.
  withr::defer(content_update(content, min_processes = 0))
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

  # A content or owner GUID that names nothing is an error, as with the v1
  # endpoint, even when falling back. (Not the nil GUID: older Connect rejects
  # it as invalid, with a 400.)
  unknown_guid <- uuid::UUIDgenerate()
  expect_error(get_processes(client, content_guid = unknown_guid), "404")
  expect_error(get_processes(client, owner_guid = unknown_guid), "404")

  # get_procs() is deprecated but returns the same process, with the server's
  # pid rather than the row index (#532).
  lifecycle::expect_deprecated(old <- get_procs(client))
  old_proc <- old[old$job_key == proc$job_key, ]
  expect_equal(nrow(old_proc), 1)
  expect_identical(old_proc$app_guid, guid)
  expect_equal(as.integer(old_proc$pid), proc$pid)
  expect_s3_class(old_proc$start_time, "POSIXct")
})
