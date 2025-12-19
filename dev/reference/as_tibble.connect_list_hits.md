# Convert usage data to a tibble

Converts an object returned by
[`get_usage()`](https://posit-dev.github.io/connectapi/dev/reference/get_usage.md)
to a tibble via
[`as.data.frame.connect_list_hits()`](https://posit-dev.github.io/connectapi/dev/reference/as.data.frame.connect_list_hits.md).

## Usage

``` r
# S3 method for class 'connect_list_hits'
as_tibble(x, ...)
```

## Arguments

- x:

  A `connect_list_hits` object.

- ...:

  Passed to
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

## Value

A tibble with one row per usage record.
