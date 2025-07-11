# Helpers to make it easier to identify where we're calling public APIs and not
v1_url <- function(...) {
  paste("v1", ..., sep = "/")
}

unversioned_url <- function(...) {
  paste(..., sep = "/")
}

# Make an alias of unversioned_url to help us be able to search for the places
# where we call the unversioned API, but not be misled by places we've left in
# for backwards compatibility.
unversioned_fallback_url <- unversioned_url

valid_page_size <- function(x, min = 1, max = 500) {
  # This could be changed to error if x is outside the range
  min(max(min, x), max)
}

generate_R6_print_output <- # nolint: object_name_linter
  function() {
    con <- Connect$new(server = "http://test_host", api_key = "test_key")
    bnd <- Bundle$new(path = "/test/path")

    ex_content <- list(
      guid = "content-guid",
      title = "content-title",
      dashboard_url = "http://test_host/connect/#/apps/content-guid/",
      url = "http://content-url"
    )
    cnt1 <- Content$new(connect = con, ex_content)

    ex_task <- list(task_id = "task-id")
    tsk1 <- ContentTask$new(connect = con, content = ex_content, task = ex_task)

    ex_vanity <- list(path_prefix = "vanity-prefix")
    van1 <- Vanity$new(connect = con, content = ex_content, vanity = ex_vanity)

    obj_list <- list(con, bnd, cnt1, tsk1, van1)

    unlist(mapply(
      function(.x, .y) {
        c(
          "----------------------------",
          .y,
          "----------------------------",
          capture.output(print(.x))
        )
      },
      .x = obj_list,
      .y = lapply(obj_list, function(x) {
        class(x)[[1]]
      }),
      SIMPLIFY = FALSE
    ))
  }

is_R6_class <- # nolint: object_name_linter
  function(instance, class) {
    return(R6::is.R6(instance) && inherits(instance, class))
  }

validate_R6_class <- # nolint: object_name_linter
  function(instance, class) {
    obj <- rlang::enquo(instance)
    if (!R6::is.R6(instance) || !inherits(instance, class)) {
      stop(paste(
        rlang::quo_text(obj),
        "must be an R6",
        glue::glue_collapse(class, sep = " or "),
        "object"
      ))
    }
    invisible(TRUE)
  }

# super useful examples
# https://github.com/tidyverse/tibble/blob/master/R/compat-lifecycle.R
warn_experimental <- function(name) {
  if (
    rlang::is_true(rlang::peek_option(
      "connectapi_disable_experimental_warnings"
    ))
  ) {
    return(invisible(NULL))
  }
  warn_once(
    msg = glue::glue(
      "The `{name}` function is experimental and subject to change without warning in a future release"
    ),
    id = paste0(name, "-experimental")
  )
}

scoped_experimental_silence <- function(frame = rlang::caller_env()) {
  rlang::local_options(
    .frame = frame,
    connectapi_disable_experimental_warnings = TRUE
  )
}

warn_dire <- function(name) {
  if (rlang::is_true(rlang::peek_option("connectapi_disable_dire_warnings"))) {
    return(invisible(NULL))
  }
  warn_once(
    msg = glue::glue(
      "DO NOT USE IN PRODUCTION - The {name} function is for internal testing purposes only"
    ),
    id = paste0(name, "-dire")
  )
}

scoped_dire_silence <- function(frame = rlang::caller_env()) {
  rlang::local_options(
    .frame = frame,
    connectapi_disable_dire_warnings = TRUE
  )
}

warn_once <- function(msg, id = msg, ...) {
  if (rlang::is_true(rlang::peek_option("connectapi_disable_warnings"))) {
    return(invisible(NULL))
  }

  rlang::warn(msg, .frequency = "once", .frequency_id = id, ...)
}

check_connect_license <- function(url) {
  if (is_R6_class(url, "Connect")) {
    url <- url$server
  }
  res <- httr::GET(glue::glue("{url}/__ping__"))
  if (res$status_code == 402) {
    stop(glue::glue("ERROR: The Connect server's license is expired ({url})"))
  }
  invisible(res)
}

simplify_version <- function(version) {
  sub("([0-9]+\\.[0-9]+\\.[0-9]+).*", "\\1", version)
}

safe_server_settings <- function(client) {
  srv <- tryCatch(
    {
      client$server_settings()
    },
    error = function(e) {
      message(
        glue::glue(
          "Problem talking to Posit Connect at {client$server}/__api__/server_settings"
        )
      )
      stop(e)
    }
  )
  return(srv)
}

safe_server_version <- function(client) {
  version <- safe_server_settings(client)$version
  if (is.null(version) || nchar(version) == 0) {
    version <- NA
  }
  version
}

error_if_less_than <- function(using_version, tested_version) {
  if (is.na(using_version)) {
    msg <- glue::glue(
      "WARNING: This feature requires Posit Connect version {tested_version} ",
      "but the server version is not exposed by this Posit Connect instance. ",
      "You may experience errors when using this functionality."
    )
    warn_once(msg)
    return(invisible())
  }
  comp <- compare_connect_version(using_version, tested_version)
  if (comp < 0) {
    msg <- glue::glue(
      "ERROR: This feature requires Posit Connect version {tested_version} ",
      "but you are using {using_version}. Please upgrade Posit Connect."
    )
    stop(msg)
  }
  invisible()
}

compare_connect_version <- function(using_version, tested_version) {
  as.integer(
    compareVersion(
      simplify_version(using_version),
      simplify_version(tested_version)
    )
  )
}

warn_untested_connect <- function(
  using_version,
  minimum_tested_version = "1.8.8.2"
) {
  comp <- compare_connect_version(using_version, minimum_tested_version)
  if (!is.na(using_version) && (comp < 0)) {
    warn_once(
      glue::glue(
        "You are using an older version of Posit Connect ",
        "({using_version}) than is tested ({minimum_tested_version}). ",
        "Some APIs may not function as expected."
      ),
      id = "old-connect"
    )
  }
  invisible()
}

token_hex <- function(n) {
  raw <- as.raw(sample(0:255, n, replace = TRUE))
  paste(as.character(raw), collapse = "")
}

# Checks to see if an http status contains a 404 error, and that that 404
# response does not contain an error code indicating that an endpoint was called
# but encountered a 404 for some other reason.
endpoint_does_not_exist <- function(res) {
  httr::status_code(res) == "404" &&
    !("code" %in% names(httr::content(res, as = "parsed")))
}

# Extract the Connect error code from a response
error_code <- function(res) {
  cont <- httr::content(res)
  if ("code" %in% names(cont)) {
    cont[["code"]]
  } else {
    # Return -1 if there is no error, just so we aren't comparing NA or NULL
    -1
  }
}

# Returns `TRUE` if we're running on Connect as determined by the
# `RSTUDIO_PRODUCT` env var, else `FALSE`.
on_connect <- function() {
  Sys.getenv("RSTUDIO_PRODUCT") == "CONNECT"
}

# Returns `TRUE` if running via testthat
is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

# Calls `message()` if not running in testthat. Useful for messages that would
# otherwise appear very frequently in test output.
message_if_not_testing <- function(...) {
  if (!is_testing()) {
    message(...)
  }
}
