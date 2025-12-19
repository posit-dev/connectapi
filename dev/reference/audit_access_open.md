# Audit Access Controls

**\[experimental\]**

## Usage

``` r
audit_access_open(content, type = "all")
```

## Arguments

- content:

  `data.frame` of content information, as from
  [`get_content()`](https://posit-dev.github.io/connectapi/dev/reference/get_content.md)

- type:

  One of "all" or "logged_in". If "all", return a list of apps whose
  access control is set to "Everyone". If "logged_in", return a list of
  apps whose access control is set to "All logged in users"

## See also

Other audit functions:
[`audit_r_versions()`](https://posit-dev.github.io/connectapi/dev/reference/audit_r_versions.md),
[`audit_runas()`](https://posit-dev.github.io/connectapi/dev/reference/audit_runas.md),
[`vanity_is_available()`](https://posit-dev.github.io/connectapi/dev/reference/vanity_is_available.md)
