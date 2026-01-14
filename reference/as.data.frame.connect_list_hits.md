# Convert usage data to a data frame

Converts an object returned by
[`get_usage()`](https://posit-dev.github.io/connectapi/reference/get_usage.md)
into a data frame with parsed column types. By default, extracts `path`
and `user_agent` from the `data` field, if available.

## Usage

``` r
# S3 method for class 'connect_list_hits'
as.data.frame(x, row.names = NULL, optional = FALSE, ..., unnest = TRUE)
```

## Arguments

- x:

  A `connect_list_hits` object (from
  [`get_usage()`](https://posit-dev.github.io/connectapi/reference/get_usage.md)).

- row.names:

  Passed to
  [`base::as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

- optional:

  Passed to
  [`base::as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

- ...:

  Passed to
  [`base::as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

- unnest:

  Logical; if `TRUE` (default), extracts nested fields using tidyr. Set
  to `FALSE` to skip unnesting.

## Value

A `data.frame` with one row per usage record.
