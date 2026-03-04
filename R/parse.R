# because format(NULL, "%Y-%m") == "NULL"
safe_format <- function(expr, ...) {
  if (is.null(expr)) {
    return(NULL)
  } else {
    return(format(expr, ...))
  }
}

datetime_to_rfc3339 <- function(input) {
  tmp <- format(input, format = "%Y-%m-%dT%H:%M:%OS5%z")
  ln <- nchar(tmp)
  paste0(substr(tmp, 0, ln - 2), ":", substr(tmp, ln - 1, ln))
}

make_timestamp <- function(input) {
  if (is.character(input)) {
    # TODO: make sure this is the right timestamp format
    return(input)
  }

  # In the call to `safe_format`:
  # - The format specifier adds a literal "Z" to the end of the timestamp, which
  #   tells Connect "This is UTC".
  # - The `tz` argument tells R to produce times in the UTC time zone.
  # - The `usetz` argument says "Don't concatenate ' UTC' to the end of the string".
  safe_format(input, "%Y-%m-%dT%H:%M:%SZ", tz = "UTC", usetz = FALSE)
}

parse_connectapi_typed <- function(data, datetime_cols = character()) {
  df <- parse_connectapi(data)
  for (col in intersect(datetime_cols, names(df))) {
    df[[col]] <- coerce_datetime(df[[col]])
  }
  df
}

# Build a tibble column-by-column instead of row-by-row (via list_rbind).
# This avoids type conflicts when the same field is NULL in some rows and
# non-NULL in others: NULL -> NA, and unlist() coerces that NA to match the
# type of the non-null values in the same column.
parse_connectapi <- function(data) {
  if (length(data) == 0) return(tibble::tibble())

  all_names <- unique(unlist(lapply(data, names)))
  cols <- stats::setNames(lapply(all_names, function(nm) {
    # NULL / missing fields become NA; unlist() will coerce to the right type
    values <- lapply(data, function(row) row[[nm]] %||% NA)
    if (any(vapply(values, function(v) is.list(v) || length(v) > 1, logical(1)))) {
      # List column: wrap scalars so every element is a list
      lapply(values, function(v) if (is.list(v)) v else list(v))
    } else {
      # Scalar column: simplify to a vector
      unlist(values)
    }
  }), all_names)
  tibble::as_tibble(cols)
}

coerce_datetime <- function(x) {
  if (is.null(x)) {
    as.POSIXct(character(), tz = Sys.timezone())
  } else if (is.numeric(x)) {
    as.POSIXct(as.double(x), origin = "1970-01-01", tz = Sys.timezone())
  } else if (is.character(x)) {
    parse_connect_rfc3339(x)
  } else if (inherits(x, "POSIXct")) {
    x
  } else if (all(is.logical(x) & is.na(x)) && length(x) > 0) {
    as.POSIXct(NA, tz = Sys.timezone())
  } else {
    stop(
      "Cannot coerce ", class(x)[[1]], " to POSIXct",
      call. = FALSE
    )
  }
}

# nolint start: commented_code_linter
# Parses a character vector of dates received from Connect, using use RFC 3339,
# returning a vector of POSIXct datetimes.
#
# R parses character timestamps as ISO 8601. When specifying %z, it expects time
# zones to be specified as `-1400` to `+1400`.
#
# Connect's API sends times in a specific RFC 3339 format: indicating time zone
# offsets with `-14:00` to `+14:00`, and zero offset with `Z`.
# https://github.com/golang/go/blob/54fe0fd43fcf8609666c16ae6d15ed92873b1564/src/time/format.go#L86
# For example:
# - "2023-08-22T14:13:14Z"
# - "2023-08-22T15:13:14+01:00"
# - "2020-01-01T00:02:03-01:00"
# nolint end
parse_connect_rfc3339 <- function(x) {
  # Convert timestamps with offsets to a format recognized by `strptime`.
  x <- gsub("([+-]\\d\\d):(\\d\\d)$", "\\1\\2", x)
  x <- gsub("Z$", "+0000", x)

  # Parse with an inner call to `strptime()`, which returns a POSIXlt object,
  # and convert that to `POSIXct`.
  #
  # We must specify `tz` in the inner call to correctly compute date math.
  # Specifying `tz` when in the outer call just changes the time zone without
  # doing any date math!
  #
  # > xlt [1] "2024-08-29 16:36:33 EDT" tzone(xlt) [1] "America/New_York"
  # as.POSIXct(xlt, tz = "UTC") [1] "2024-08-29 16:36:33 UTC"
  format_string <- "%Y-%m-%dT%H:%M:%OS%z"
  as.POSIXct(x, format = format_string, tz = Sys.timezone())
}
