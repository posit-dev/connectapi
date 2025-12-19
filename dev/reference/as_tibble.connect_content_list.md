# Convert integration list to a tibble

Converts a list returned by
[`search_content()`](https://posit-dev.github.io/connectapi/dev/reference/search_content.md)
to a tibble.

## Usage

``` r
# S3 method for class 'connect_content_list'
as_tibble(x, ...)
```

## Arguments

- x:

  A `connect_content_list` object.

- ...:

  Unused.

## Value

A tibble with one row per content item.
