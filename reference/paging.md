# Paging

Helper functions that make paging easier in the Posit Connect Server
API.

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

  The request that needs to be paged

- limit:

  A row limit

## Value

The aggregated results from all requests

The aggregated results from all requests
