# Audit Run As Settings

**\[experimental\]**

## Usage

``` r
audit_runas(content)
```

## Arguments

- content:

  `data.frame` of content information, as from
  [`get_content()`](https://posit-dev.github.io/connectapi/reference/get_content.md)

## Value

A data frame with the app name and the Run As user if the Run As user is
not the default

## See also

Other audit functions:
[`audit_access_open()`](https://posit-dev.github.io/connectapi/reference/audit_access_open.md),
[`audit_r_versions()`](https://posit-dev.github.io/connectapi/reference/audit_r_versions.md),
[`vanity_is_available()`](https://posit-dev.github.io/connectapi/reference/vanity_is_available.md)
