# Package dependencies for a content item

Get a data frame of package dependencies used by a content item.

## Usage

``` r
get_content_packages(content)
```

## Arguments

- content:

  A content item

## Value

A data frame with the following columns:

- `language` : Language ecosystem the package belongs to (`r` or
  `python`)

- `name`: The package name

- `version`: The package version

- `hash`: For R packages, the package `DESCRIPTION` hash

## See also

Other packages functions:
[`get_packages()`](https://posit-dev.github.io/connectapi/dev/reference/get_packages.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()
item <- content_item(client, "951bf3ad-82d0-4bca-bba8-9b27e35c49fa")
packages <- get_content_packages(item)
} # }
```
