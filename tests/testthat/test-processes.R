# A MockConnect that also records the extra arguments (headers, query) passed
# to each request, so tests can check what would be sent to the server.
CapturingConnect <- R6Class(
  "CapturingConnect",
  inherit = MockConnect,
  public = list(
    request_args = list(),
    request = function(method, url, ..., parser = "parsed", simplify = FALSE) {
      self$request_args <- c(self$request_args, list(rlang::list2(...)))
      super$request(method, url, ..., parser = parser, simplify = simplify)
    }
  )
)

# Pull the value of a request header out of recorded request arguments.
sent_header <- function(args, name) {
  for (arg in args) {
    if (inherits(arg, "request")) {
      return(unname(arg$headers[name]))
    }
  }
  NULL
}

# The CSV `GET /v1/system/processes` returns, in the format Connect writes it
# (Go's encoding/csv): null values are empty fields, and fields containing
# commas or quotes are quoted.
processes_csv <- paste0(
  "content_guid,content_name,content_url,run_as,type,pid,hostname,job_key,",
  "image,start_time,heartbeat,cpu_current,ram\n",
  "6f300623-1e0c-48e6-a473-ddf630c0c0c3,\"Sales, by \"\"region\"\"\",",
  "https://connect.example/sales/,rstudio-connect,run_app,20253,node-1,",
  "tHawGvHZTosJA2Dx,,2026-11-06T10:00:00Z,2026-11-06T10:05:00Z,0.25,104857600\n",
  "a1b2c3d4-0000-4000-8000-000000000000,Model API,",
  "https://connect.example/content/a1b2c3d4-0000-4000-8000-000000000000/,,",
  "run_app,,,Jz3kQ9xYwPq1LmNo,ghcr.io/rstudio/content-base:r4.4.1-jammy,",
  "2026-11-06T10:01:00-05:00,,,\n"
)

processes_csv_header <- paste0(
  "content_guid,content_name,content_url,run_as,type,pid,hostname,job_key,",
  "image,start_time,heartbeat,cpu_current,ram\n"
)

# The JSON `GET /metrics/procs` returns for the same two processes. It uses
# placeholders ("unknown", "unknown host", "", 0) where the v1 endpoint uses
# null.
legacy_procs_json <- list(
  list(
    app_id = "12",
    app_guid = "6f300623-1e0c-48e6-a473-ddf630c0c0c3",
    app_name = "Sales, by \"region\"",
    app_url = "https://connect.example/sales/",
    app_run_as = "rstudio-connect",
    type = "run_app",
    cpu_current = 0.25,
    ram = 104857600,
    hostname = "node-1",
    job_key = "tHawGvHZTosJA2Dx",
    image = "",
    start_time = "2026-11-06T10:00:00Z",
    heartbeat = "2026-11-06T10:05:00Z",
    pid = 20253
  ),
  list(
    app_id = "34",
    app_guid = "a1b2c3d4-0000-4000-8000-000000000000",
    app_name = "Model API",
    app_url = "https://connect.example/content/a1b2c3d4-0000-4000-8000-000000000000/",
    app_run_as = "unknown",
    type = "run_app",
    cpu_current = NULL,
    ram = NULL,
    hostname = "unknown host",
    job_key = "Jz3kQ9xYwPq1LmNo",
    image = "ghcr.io/rstudio/content-base:r4.4.1-jammy",
    start_time = "2026-11-06T10:01:00-05:00",
    heartbeat = NULL,
    pid = 0
  )
)

mock_v1_processes <- function(client, content = processes_csv) {
  client$mock_response(
    "GET",
    "v1/system/processes",
    content = content,
    headers = c("Content-Type" = "text/csv")
  )
}

# How Connect versions without the v1 endpoint answer it: a 404 without a
# Connect error code.
mock_v1_processes_missing <- function(client) {
  client$mock_response(
    "GET",
    "v1/system/processes",
    content = "404 page not found",
    status_code = 404L,
    headers = c("Content-Type" = "text/plain; charset=utf-8")
  )
}

expect_process_types <- function(df) {
  expect_s3_class(df, "tbl_df")
  expect_named(df, process_columns)
  for (col in c(
    "content_guid",
    "content_name",
    "content_url",
    "run_as",
    "type",
    "hostname",
    "job_key",
    "image"
  )) {
    expect_type(df[[col]], "character")
  }
  expect_type(df$pid, "integer")
  expect_type(df$cpu_current, "double")
  expect_s3_class(df$ram, "fs_bytes")
  expect_s3_class(df$start_time, "POSIXct")
  expect_s3_class(df$heartbeat, "POSIXct")
}

test_that("get_processes() requests CSV from v1/system/processes and parses it", {
  client <- CapturingConnect$new()
  mock_v1_processes(client)

  procs <- get_processes(client)

  expect_identical(
    client$call_log,
    "GET https://connect.example/__api__/v1/system/processes"
  )
  expect_identical(
    sent_header(client$request_args[[1]], "Accept"),
    "text/csv"
  )

  expect_process_types(procs)
  expect_equal(nrow(procs), 2)
  expect_identical(
    procs$content_guid,
    c("6f300623-1e0c-48e6-a473-ddf630c0c0c3", "a1b2c3d4-0000-4000-8000-000000000000")
  )
  expect_identical(procs$content_name, c("Sales, by \"region\"", "Model API"))
  expect_identical(procs$run_as, c("rstudio-connect", NA))
  expect_identical(procs$pid, c(20253L, NA))
  expect_identical(procs$hostname, c("node-1", NA))
  expect_identical(
    procs$image,
    c(NA, "ghcr.io/rstudio/content-base:r4.4.1-jammy")
  )
  expect_equal(procs$cpu_current, c(0.25, NA))
  expect_equal(procs$ram, fs::as_fs_bytes(c(104857600, NA)))
  expect_equal(
    procs$start_time,
    as.POSIXct(c("2026-11-06 10:00:00", "2026-11-06 15:01:00"), tz = "UTC"),
    ignore_attr = "tzone"
  )
  expect_equal(
    procs$heartbeat,
    as.POSIXct(c("2026-11-06 10:05:00", NA), tz = "UTC"),
    ignore_attr = "tzone"
  )
})

test_that("get_processes() passes filters as query parameters", {
  client <- CapturingConnect$new()
  mock_v1_processes(client)

  get_processes(
    client,
    content_guid = "6f300623-1e0c-48e6-a473-ddf630c0c0c3",
    owner_guid = "0d2c5e1a-7b4f-4f3e-9a8b-1c2d3e4f5a6b",
    hostname = "node-1"
  )
  expect_identical(
    client$request_args[[1]]$query,
    list(
      content_guid = "6f300623-1e0c-48e6-a473-ddf630c0c0c3",
      owner_guid = "0d2c5e1a-7b4f-4f3e-9a8b-1c2d3e4f5a6b",
      hostname = "node-1"
    )
  )

  # Unset filters are NULL, which httr drops from the query string.
  client <- CapturingConnect$new()
  mock_v1_processes(client)
  get_processes(client, hostname = "node-1")
  expect_null(client$request_args[[1]]$query$content_guid)
  expect_null(client$request_args[[1]]$query$owner_guid)
  expect_identical(client$request_args[[1]]$query$hostname, "node-1")
})

test_that("get_processes() validates filters", {
  client <- MockConnect$new()
  expect_error(get_processes(client, content_guid = 1), "`content_guid`")
  expect_error(get_processes(client, hostname = c("a", "b")), "`hostname`")
  expect_length(client$call_log, 0)
})

test_that("get_processes() returns a typed, zero-row tibble when nothing is running", {
  client <- MockConnect$new()
  mock_v1_processes(client, processes_csv_header)
  procs <- get_processes(client)
  expect_equal(nrow(procs), 0)
  expect_process_types(procs)
})

test_that("get_processes() keeps columns added by newer Connect versions", {
  client <- MockConnect$new()
  mock_v1_processes(
    client,
    paste0(
      "content_guid,content_name,content_url,run_as,type,pid,hostname,job_key,",
      "image,start_time,heartbeat,cpu_current,ram,new_field\n",
      "6f300623-1e0c-48e6-a473-ddf630c0c0c3,a,b,c,run_app,1,h,k,,",
      "2026-11-06T10:00:00Z,,,,surprise\n"
    )
  )
  procs <- get_processes(client)
  expect_named(procs, c(process_columns, "new_field"))
  expect_identical(procs$new_field, "surprise")
})

test_that("get_processes() does not fall back on a 404 with a Connect error code", {
  # e.g. an unknown `content_guid`.
  client <- MockConnect$new()
  client$mock_response(
    "GET",
    "v1/system/processes",
    content = list(code = 4, error = "The requested object does not exist."),
    status_code = 404L
  )
  expect_error(
    get_processes(client, content_guid = "6f300623-1e0c-48e6-a473-ddf630c0c0c3"),
    "404"
  )
  expect_identical(
    client$call_log,
    "GET https://connect.example/__api__/v1/system/processes"
  )
})

test_that("get_processes() falls back to metrics/procs on older Connect", {
  rlang::local_options(lifecycle_verbosity = "warning")
  client <- MockConnect$new()
  mock_v1_processes_missing(client)
  client$mock_response("GET", "metrics/procs", content = legacy_procs_json)

  # The fallback must not raise get_procs()'s deprecation warning. The class is
  # needed: without it, expect_no_warning() ignores deprecation warnings.
  expect_no_warning(
    procs <- get_processes(client),
    class = "lifecycle_warning_deprecated"
  )

  expect_identical(
    client$call_log,
    c(
      "GET https://connect.example/__api__/v1/system/processes",
      "GET https://connect.example/__api__/metrics/procs"
    )
  )

  # Same columns, types, and values as the v1 endpoint returns for the same
  # processes.
  v1_client <- MockConnect$new()
  mock_v1_processes(v1_client)
  expect_equal(procs, get_processes(v1_client))
})

test_that("get_processes() fallback returns a typed, zero-row tibble when nothing is running", {
  client <- MockConnect$new()
  mock_v1_processes_missing(client)
  client$mock_response("GET", "metrics/procs", content = "[]")
  procs <- get_processes(client)
  expect_equal(nrow(procs), 0)
  expect_process_types(procs)
})

test_that("get_processes() fallback applies the filters client-side", {
  mock_fallback <- function() {
    client <- MockConnect$new()
    mock_v1_processes_missing(client)
    client$mock_response("GET", "metrics/procs", content = legacy_procs_json)
    client
  }

  client <- mock_fallback()
  procs <- get_processes(client, content_guid = "a1b2c3d4-0000-4000-8000-000000000000")
  expect_identical(procs$job_key, "Jz3kQ9xYwPq1LmNo")

  client <- mock_fallback()
  procs <- get_processes(client, hostname = "node-1")
  expect_identical(procs$job_key, "tHawGvHZTosJA2Dx")

  client <- mock_fallback()
  procs <- get_processes(client, hostname = "node-2")
  expect_equal(nrow(procs), 0)
  expect_process_types(procs)

  # owner_guid is resolved to the owner's content items.
  client <- mock_fallback()
  client$mock_response(
    "GET",
    "v1/content",
    content = list(list(guid = "6f300623-1e0c-48e6-a473-ddf630c0c0c3"))
  )
  procs <- get_processes(client, owner_guid = "0d2c5e1a-7b4f-4f3e-9a8b-1c2d3e4f5a6b")
  expect_identical(procs$job_key, "tHawGvHZTosJA2Dx")
  expect_identical(
    client$call_log[[3]],
    "GET https://connect.example/__api__/v1/content"
  )

  # Filters are ANDed.
  client <- mock_fallback()
  procs <- get_processes(
    client,
    content_guid = "6f300623-1e0c-48e6-a473-ddf630c0c0c3",
    hostname = "node-2"
  )
  expect_equal(nrow(procs), 0)
})

test_that("get_procs() is deprecated in favor of get_processes()", {
  client <- MockConnect$new()
  client$mock_response("GET", "metrics/procs", content = legacy_procs_json)
  lifecycle::expect_deprecated(get_procs(client), "get_processes")
})

test_that("get_procs() returns the server's pid and parses datetimes", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  client <- MockConnect$new()
  client$mock_response("GET", "metrics/procs", content = legacy_procs_json)

  procs <- get_procs(client)

  expect_identical(
    client$call_log,
    "GET https://connect.example/__api__/metrics/procs"
  )
  # Previously the pid column held the row index (1, 2) instead (#532).
  expect_equal(procs$pid, c(20253, 0))
  expect_identical(procs$app_guid, purrr::map_chr(legacy_procs_json, "app_guid"))
  expect_s3_class(procs$start_time, "POSIXct")
  expect_s3_class(procs$heartbeat, "POSIXct")
  expect_s3_class(procs$ram, "fs_bytes")
})

test_that("get_procs() handles the old response keyed by PID", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  client <- MockConnect$new()
  client$mock_response(
    "GET",
    "metrics/procs",
    content = list(
      "20253" = list(appGuid = "6f300623-1e0c-48e6-a473-ddf630c0c0c3", type = "run_app"),
      "20254" = list(appGuid = "a1b2c3d4-0000-4000-8000-000000000000", type = "run_app")
    )
  )
  procs <- get_procs(client)
  expect_identical(procs$pid, c("20253", "20254"))
  expect_identical(
    procs$appGuid,
    c("6f300623-1e0c-48e6-a473-ddf630c0c0c3", "a1b2c3d4-0000-4000-8000-000000000000")
  )
})
