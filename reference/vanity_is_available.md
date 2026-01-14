# Check to see if a vanity URL is currently in use

**\[experimental\]**

## Usage

``` r
vanity_is_available(connect, vanity)
```

## Arguments

- connect:

  A Connect R6 object

- vanity:

  string of the vanity URL to check

## Value

logical indicating if the vanity URL is available.

## See also

Other audit functions:
[`audit_access_open()`](https://posit-dev.github.io/connectapi/reference/audit_access_open.md),
[`audit_r_versions()`](https://posit-dev.github.io/connectapi/reference/audit_r_versions.md),
[`audit_runas()`](https://posit-dev.github.io/connectapi/reference/audit_runas.md)
