# Get group information from the Posit Connect server

Get group information from the Posit Connect server

## Usage

``` r
get_groups(src, page_size = 500, prefix = NULL, limit = Inf)
```

## Arguments

- src:

  The source object.

- page_size:

  The number of records to return per page (max 500).

- prefix:

  Filters groups by prefix (group name). The filter is case insensitive.

- limit:

  The number of groups to retrieve before paging stops. Default is to
  return all results; however, for Connect server versions older than
  2025.04.0, `limit` is capped at 500 when `prefix` is provided.

## Value

A tibble with the following columns:

- `guid`: The unique identifier of the group

- `name`: The group name

- `owner_guid`: The group owner's unique identifier. When using LDAP or
  Proxied authentication with group provisioning enabled this property
  will always be null.

## Details

Please see https://docs.posit.co/connect/api/#get-/v1/groups for more
information.

## See also

Other groups functions:
[`get_group_content()`](https://posit-dev.github.io/connectapi/dev/reference/get_group_content.md),
[`get_group_members()`](https://posit-dev.github.io/connectapi/dev/reference/get_group_members.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(connectapi)
client <- connect()

# get all groups
get_groups(client, limit = Inf)
} # }
```
