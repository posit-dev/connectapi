# Convert integrations list to a data frame

Converts a list returned by
[`get_integrations()`](https://posit-dev.github.io/connectapi/reference/get_integrations.md)
into a data frame.

## Usage

``` r
# S3 method for class 'connect_integration_list'
as.data.frame(x, row.names = NULL, optional = FALSE, ...)
```

## Arguments

- x:

  A `connect_integration_list` object (from
  [`get_integrations()`](https://posit-dev.github.io/connectapi/reference/get_integrations.md)).

- row.names:

  Passed to
  [`base::as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

- optional:

  Passed to
  [`base::as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

- ...:

  Passed to
  [`base::as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

## Value

A `data.frame` with one row per integration.
