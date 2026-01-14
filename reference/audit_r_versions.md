# Audit R Versions

**\[experimental\]**

## Usage

``` r
audit_r_versions(content)
```

## Arguments

- content:

  `data.frame` of content information, as from
  [`get_content()`](https://posit-dev.github.io/connectapi/reference/get_content.md)

## Value

A plot that shows the R version used by content over time and in
aggregate.

## See also

Other audit functions:
[`audit_access_open()`](https://posit-dev.github.io/connectapi/reference/audit_access_open.md),
[`audit_runas()`](https://posit-dev.github.io/connectapi/reference/audit_runas.md),
[`vanity_is_available()`](https://posit-dev.github.io/connectapi/reference/vanity_is_available.md)
