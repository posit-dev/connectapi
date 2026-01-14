# Get all vanity URLs

Get a table of all vanity URLs on the server. Requires administrator
privileges.

## Usage

``` r
get_vanity_urls(client)
```

## Arguments

- client:

  A `Connect` object.

## Value

A tibble with columns for `content_guid`, `path`, and `created_time`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(connectapi)
client <- connect()
get_vanity_urls(client)
} # }
```
