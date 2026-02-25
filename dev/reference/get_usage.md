# Get usage information for deployed content

Retrieve content hits for all available content on the server. Available
content depends on the user whose API key is in use. Administrator
accounts will receive data for all content on the server. Publishers
will receive data for all content they own or collaborate on.

If no date-times are provided, all usage data will be returned.

## Usage

``` r
get_usage(client, content_guid = NULL, from = NULL, to = NULL)
```

## Arguments

- client:

  A `Connect` R6 client object.

- content_guid:

  Optional. A single content GUID or a character vector of GUIDs to
  filter results. When multiple GUIDs are provided they are collapsed
  with `"|"`.

- from:

  Optional date-time (`POSIXct` or `POSIXlt`). Only records after this
  time are returned. If not provided, records are returned back to the
  first record available.

- to:

  Optional date-time (`POSIXct` or `POSIXlt`). Only records before this
  time are returned. If not provided, all records up to the most recent
  are returned.

## Value

A list of usage records. Each record is a list with all elements as
character strings unless otherwise specified.

- `id`: An integer identifier for the hit.

- `user_guid`: The user GUID if the visitor is logged-in, `NULL` for
  anonymous hits.

- `content_guid`: The GUID of the visited content.

- `timestamp`: The time of the hit in RFC3339 format.

- `data`: A nested list with optional fields:

  - `path`: The request path (if recorded).

  - `user_agent`: The user agent string (if available).

Use [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) or
[`tibble::as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html)
to convert to a flat table with parsed types. In the resulting data
frame:

- `timestamp` is parsed to `POSIXct`.

- `path` and `user_agent` are extracted from the nested `data` field.

By default,
[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) attempts
to extract the nested fields using the tidyr package. If tidyr is not
available, or if you want to skip unnesting, call
`as.data.frame(x, unnest = FALSE)` to leave `data` as a list-column.

## Details

The data returned by `get_usage()` includes all content types. For Shiny
content, the `timestamp` indicates the *start* of the Shiny session.
Additional fields for Shiny and non-Shiny are available respectively
from
[`get_usage_shiny()`](https://posit-dev.github.io/connectapi/dev/reference/get_usage_shiny.md)
and
[`get_usage_static()`](https://posit-dev.github.io/connectapi/dev/reference/get_usage_static.md).
[`get_usage_shiny()`](https://posit-dev.github.io/connectapi/dev/reference/get_usage_shiny.md)
includes a field for the session end time;
[`get_usage_static()`](https://posit-dev.github.io/connectapi/dev/reference/get_usage_static.md)
includes variant, rendering, and bundle identifiers for the visited
content.

When possible, however, we recommend using `get_usage()` over
[`get_usage_static()`](https://posit-dev.github.io/connectapi/dev/reference/get_usage_static.md)
or
[`get_usage_shiny()`](https://posit-dev.github.io/connectapi/dev/reference/get_usage_shiny.md),
as it is faster and more efficient.

## See also

[`as.data.frame.connect_list_hits()`](https://posit-dev.github.io/connectapi/dev/reference/as.data.frame.connect_list_hits.md),
[`as_tibble.connect_list_hits()`](https://posit-dev.github.io/connectapi/dev/reference/as_tibble.connect_list_hits.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()

# Fetch the last 2 days of hits
usage <- get_usage(client, from = Sys.Date() - 2, to = Sys.Date())

# Fetch usage after a specified date and convert to a data frame.
usage <- get_usage(
  client,
  from = as.POSIXct("2025-05-02 12:40:00", tz = "UTC")
)

# Fetch usage for a specific content item
usage <- get_usage(client, content_guid = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")

# Fetch all usage
usage <- get_usage(client)

# Convert to tibble or data frame
usage_df <- tibble::as_tibble(usage)

# Skip unnesting if tidyr is not installed
usage_df <- as.data.frame(usage, unnest = FALSE)
} # }
```
