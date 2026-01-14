# Convert content list to a data frame

Converts a list returned by
[`search_content()`](https://posit-dev.github.io/connectapi/reference/search_content.md)
into a data frame.

## Usage

``` r
# S3 method for class 'connect_content_list'
as.data.frame(x, row.names = NULL, optional = FALSE, ...)
```

## Arguments

- x:

  A `connect_content_list` object (from
  [`search_content()`](https://posit-dev.github.io/connectapi/reference/search_content.md)).

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

A `data.frame` with one row per content item.
