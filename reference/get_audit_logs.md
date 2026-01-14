# Get Audit Logs from Posit Connect Server

Get Audit Logs from Posit Connect Server

## Usage

``` r
get_audit_logs(src, limit = 500, previous = NULL, nxt = NULL, asc_order = TRUE)
```

## Arguments

- src:

  The source object

- limit:

  The number of records to return.

- previous:

  Retrieve the previous page of Shiny application usage logs relative to
  the provided value. This value corresponds to an internal reference
  within the server and should be sourced from the appropriate attribute
  within the paging object of a previous response.

- nxt:

  Retrieve the next page of Shiny application usage logs relative to the
  provided value. This value corresponds to an internal reference within
  the server and should be sourced from the appropriate attribute within
  the paging object of a previous response.

- asc_order:

  Defaults to TRUE; Determines if the response records should be listed
  in ascending or descending order within the response. Ordering is by
  the started timestamp field.

## Value

A tibble with the following columns:

- `id`: ID of the audit action

- `time`: Timestamp in RFC3339 format when action was taken

- `user_id`: User ID of the actor who made the audit action

- `user_description`: Description of the actor

- `action`: Audit action taken

- `event_description`: Description of action

## Details

Please see https://docs.posit.co/connect/api/#get-/v1/audit_logs for
more information.

## Examples

``` r
if (FALSE) { # \dontrun{
library(connectapi)
client <- connect()

# get the last 20 audit logs
get_audit_logs(client, limit = 20, asc_order = FALSE)
} # }
```
