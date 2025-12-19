# Convert integration list to a tibble

Converts a list returned by
[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md)
to a tibble.

## Usage

``` r
# S3 method for class 'connect_integration_list'
as_tibble(x, ...)
```

## Arguments

- x:

  A `connect_integration_list` object.

- ...:

  Unused.

## Value

A tibble with one row per integration.
