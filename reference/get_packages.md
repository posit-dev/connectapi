# All package dependencies on the server

Get a data frame of package dependencies used by all content items on
the server.

## Usage

``` r
get_packages(src, name = NULL, page_size = 100000, limit = Inf)
```

## Arguments

- src:

  A `Connect` client object.

- name:

  Optional package name to filter by. Python package are normalized
  during matching; R package names must match exactly.

- page_size:

  Optional. Integer specifying page size for API paging.

- limit:

  Optional. Specify the maximum number of records after which to cease
  paging.

## Value

A data frame with the following columns:

- `language`: Language ecosystem the package belongs to (`r` or
  `python`)

- `language_version`: Version of R or Python used by the content

- `name`: Package name

- `version`: Package version

- `hash`: Package description hash for R packages

- `bundle_id`: Identifier for the bundle that depends on this package

- `content_id`: Numeric identifier for the content that depends on this
  package

- `content_guid`: The unique identifier of the content item that depends
  on this package

## See also

Other packages functions:
[`get_content_packages()`](https://posit-dev.github.io/connectapi/reference/get_content_packages.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()
packages <- get_packages(client)
} # }
```
