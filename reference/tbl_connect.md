# Connect Tibble

**\[experimental\]** A lazy tibble that automatically pages through API
requests when `collect`ed.

## Usage

``` r
tbl_connect(
  src,
  from = c("users", "groups", "content", "usage_shiny", "usage_static", "audit_logs"),
  ...
)
```

## Arguments

- src:

  The source object

- from:

  The type of tibble

- ...:

  Additional arguments that are not yet implemented

## Value

A `tbl_connect` object
