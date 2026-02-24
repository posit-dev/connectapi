# Paging

Helper functions that make paging easier in the Posit Connect Server
API.

## Usage

``` r
page_cursor(client, req, limit = Inf)

page_offset(client, req, limit = Inf)
```

## Arguments

- client:

  A Connect client object

- req:

  For page_cursor, the output from an initial response to an API
  endpoint that uses cursor-based pagination. For page_offset, a request
  that needs to be paged.

- limit:

  A row limit

## Value

The aggregated results from all requests
