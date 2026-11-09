#' Get running processes
#'
#' Returns the processes that Connect has started for content and that have
#' not yet finished, with their most recent CPU and memory use. This is the
#' data shown on the **System > Processes** page of the Connect dashboard. It
#' requires administrator privileges.
#'
#' The results cover every node in a Highly Available cluster and include
#' processes that run with off-host execution (e.g. Kubernetes).
#'
#' Note that:
#'
#' * `cpu_current`, `ram`, and `heartbeat` hold the last measurement each
#'   process reported, so they can be a few seconds old. They are `NA` until a
#'   process reports its first measurement.
#' * A process that exited recently can still appear until Connect finishes
#'   cleaning up after it.
#'
#' On Connect versions without the `GET /v1/system/processes` endpoint, this
#' falls back to the older, unversioned `GET /metrics/procs` endpoint. The
#' results are converted to the same columns, and the filters are applied
#' client-side.
#'
#' When more than one filter is given, a process must match all of them.
#'
#' @param src A Connect R6 client object.
#' @param content_guid Optional. Return only processes for the content item
#'   with this GUID. It is an error if no content item has this GUID.
#' @param owner_guid Optional. Return only processes for content owned by the
#'   user with this GUID. It is an error if no user has this GUID.
#' @param hostname Optional. Return only processes running on the Connect node
#'   with this hostname.
#'
#' @return
#' A tibble with one row per process and the following columns:
#'
#'   * `content_guid`: The GUID of the content item the process belongs to.
#'     `NA` when the content item no longer exists.
#'   * `content_name`: The title of the content item, or its name when it has
#'     no title.
#'   * `content_url`: The URL of the content item, including its custom URL if
#'     it has one.
#'   * `run_as`: The Unix user the process runs as.
#'   * `type`: The kind of work the process does, such as `run_app` or
#'     `build_report`.
#'   * `pid`: The process identifier on the Connect host. `NA` when Connect
#'     has not recorded one, such as for off-host execution.
#'   * `hostname`: The name of the Connect node that started the process.
#'   * `job_key`: The key of the job for this process.
#'   * `image`: The container image the process runs in, when using off-host
#'     execution.
#'   * `start_time`: When the process started.
#'   * `heartbeat`: When the last CPU and memory measurement was taken.
#'   * `cpu_current`: The fraction of one CPU the process used over the last
#'     measurement interval.
#'   * `ram`: The resident memory of the process at the last measurement, as
#'     [fs::fs_bytes].
#'
#' @examples
#' \dontrun{
#' client <- connect()
#'
#' get_processes(client)
#'
#' # Only the processes for one content item
#' get_processes(client, content_guid = "6f300623-1e0c-48e6-a473-ddf630c0c0c3")
#' }
#'
#' @export
get_processes <- function(
  src,
  content_guid = NULL,
  owner_guid = NULL,
  hostname = NULL
) {
  validate_R6_class(src, "Connect")
  for (arg in c("content_guid", "owner_guid", "hostname")) {
    value <- get(arg)
    if (!is.null(value) && !(is_string(value) && nzchar(value))) {
      stop(
        "`",
        arg,
        "` must be a single non-empty string or `NULL`.",
        call. = FALSE
      )
    }
  }

  res <- src$GET(
    v1_url("system", "processes"),
    httr::add_headers(Accept = "text/csv"),
    query = list(
      content_guid = content_guid,
      owner_guid = owner_guid,
      hostname = hostname
    ),
    parser = NULL
  )

  if (endpoint_does_not_exist(res)) {
    # Connect versions before the v1 endpoint only have the unversioned one.
    return(legacy_processes(src, content_guid, owner_guid, hostname))
  }
  src$raise_error(res)
  type_processes(parse_processes_csv(httr::content(
    res,
    as = "text",
    encoding = "UTF-8"
  )))
}

#' Get Real-Time Process Data
#'
#' `r lifecycle::badge('deprecated')`
#'
#' This function is deprecated; please use [get_processes()], which uses the
#' supported `GET /v1/system/processes` endpoint, can filter its results, and
#' returns the same columns across Connect versions.
#'
#' `get_procs()` uses the internal, unversioned `GET /metrics/procs` endpoint,
#' so its behavior and the returned columns may change in future versions of
#' Connect. It requires administrator privileges, and returns processes across
#' all nodes in a Highly Available cluster.
#'
#' @param src The source object
#'
#' @return
#' A tibble with one row per process. The columns are those sent by the server,
#' which in recent versions of Connect are `pid`, `app_id`, `app_guid`,
#' `app_name`, `app_url`, `app_run_as`, `type`, `cpu_current`, `ram`,
#' `hostname`, `job_key`, `image`, `start_time`, and `heartbeat`.
#'
#' @keywords internal
#' @export
get_procs <- function(src) {
  lifecycle::deprecate_warn("0.13.0", "get_procs()", "get_processes()")
  validate_R6_class(src, "Connect")
  fetch_legacy_procs(src)
}

# Columns returned by `GET /v1/system/processes`, in order.
process_columns <- c(
  "content_guid",
  "content_name",
  "content_url",
  "run_as",
  "type",
  "pid",
  "hostname",
  "job_key",
  "image",
  "start_time",
  "heartbeat",
  "cpu_current",
  "ram"
)

# Read the CSV body of `GET /v1/system/processes`. Every column is read as
# character so that types do not depend on the values present; Connect writes
# null values as empty fields, so those become `NA`.
#
# Types are applied afterwards by `type_processes()` rather than through
# `colClasses`, because:
# - `type_processes()` also types the `GET /metrics/procs` fallback, whose
#   values arrive from JSON with different types, so it is needed either way.
# - `colClasses` can't produce the `start_time`/`heartbeat` or `ram` types:
#   "POSIXct" drops the time from RFC 3339 strings, and there is no class for
#   `fs_bytes`.
# - Columns not named in `colClasses` would get their types guessed (all-NA
#   columns become logical), and naming a column the server doesn't send is a
#   warning.
parse_processes_csv <- function(text) {
  if (!nzchar(trimws(text))) {
    return(tibble::tibble())
  }
  df <- utils::read.csv(
    text = text,
    colClasses = "character",
    na.strings = "",
    check.names = FALSE,
    stringsAsFactors = FALSE,
    encoding = "UTF-8"
  )
  tibble::as_tibble(df)
}

# Give a processes table its documented column types, adding any missing
# columns so that empty results have the same shape as non-empty ones. Columns
# the server sends that we don't know about are kept at the end.
type_processes <- function(df) {
  n <- nrow(df)
  for (col in setdiff(process_columns, names(df))) {
    df[[col]] <- rep(NA_character_, n)
  }
  df <- df[c(process_columns, setdiff(names(df), process_columns))]

  chr_cols <- c(
    "content_guid",
    "content_name",
    "content_url",
    "run_as",
    "type",
    "hostname",
    "job_key",
    "image"
  )
  for (col in chr_cols) {
    df[[col]] <- as.character(df[[col]])
  }
  df$pid <- as.integer(df$pid)
  df$cpu_current <- as.double(df$cpu_current)
  df$ram <- fs::as_fs_bytes(as.double(df$ram))
  df$start_time <- coerce_datetime(df$start_time)
  df$heartbeat <- coerce_datetime(df$heartbeat)
  df
}

# Fetch `GET /metrics/procs` as a tibble with the server's column names.
fetch_legacy_procs <- function(src) {
  raw <- src$GET(unversioned_fallback_url("metrics", "procs"))
  if (!is.null(names(raw))) {
    # Old Connect versions returned an object keyed by PID rather than an
    # array of processes that each carry a `pid` field.
    raw <- unname(purrr::imap(raw, function(x, pid) c(list(pid = pid), x)))
  }
  out <- parse_connectapi_typed(raw, datetime_cols = c("start_time", "heartbeat"))
  coerce_fs_bytes(out, "ram")
}

# Fallback for `get_processes()` on Connect versions without
# `GET /v1/system/processes`: fetch `GET /metrics/procs`, convert it to the v1
# columns and conventions, and apply the filters client-side.
legacy_processes <- function(src, content_guid, owner_guid, hostname) {
  # Like the v1 endpoint, reject a content or owner GUID that names nothing
  # rather than returning no processes. These requests raise a 404 if so.
  if (!is.null(content_guid)) {
    src$content(guid = content_guid, include = NULL)
  }
  if (!is.null(owner_guid)) {
    src$user(owner_guid)
    owned <- src$content(owner_guid = owner_guid, include = NULL)
    owned_guids <- purrr::map_chr(owned, "guid")
  }

  df <- fetch_legacy_procs(src)

  renames <- c(
    app_guid = "content_guid",
    app_name = "content_name",
    app_url = "content_url",
    app_run_as = "run_as",
    appGuid = "content_guid",
    appName = "content_name",
    appUrl = "content_url",
    appRunAs = "run_as",
    cpuCurrent = "cpu_current"
  )
  to_rename <- intersect(names(renames), names(df))
  names(df)[match(to_rename, names(df))] <- renames[to_rename]
  df <- df[setdiff(names(df), c("app_id", "appId", "cpuTotal"))]
  df <- type_processes(df)

  # The v1 endpoint returns null for values Connect doesn't know, where the
  # unversioned endpoint uses placeholders. Match the v1 endpoint, whose CSV
  # output also cannot distinguish an empty string from null.
  for (col in names(df)[purrr::map_lgl(df, is.character)]) {
    df[[col]][!is.na(df[[col]]) & df[[col]] == ""] <- NA_character_
  }
  df$run_as[df$run_as %in% "unknown"] <- NA_character_
  df$hostname[df$hostname %in% "unknown host"] <- NA_character_
  df$pid[!is.na(df$pid) & df$pid <= 0L] <- NA_integer_

  keep <- rep(TRUE, nrow(df))
  if (!is.null(content_guid)) {
    keep <- keep & df$content_guid %in% content_guid
  }
  if (!is.null(hostname)) {
    keep <- keep & df$hostname %in% hostname
  }
  if (!is.null(owner_guid)) {
    keep <- keep & df$content_guid %in% owned_guids
  }
  df[keep, ]
}
