# Get content access permissions for a group or groups

Get content access permissions for a group or groups

## Usage

``` r
get_group_content(src, guids)
```

## Arguments

- src:

  A Connect client object

- guids:

  A character vector of group guids

## Value

A tibble with the following columns:

- `group_guid`: The group's GUID

- `group_name`: The group's name

- `content_guid`: The content item's GUID

- `content_name`: The content item's name

- `content_title`: The content item's title

- `access_type`: The access type of the content item ("all",
  "logged_in", or "acl")

- `role`: The access type that members of the group have to the content
  item, "publisher" or "viewer".

## See also

Other groups functions:
[`get_group_members()`](https://posit-dev.github.io/connectapi/dev/reference/get_group_members.md),
[`get_groups()`](https://posit-dev.github.io/connectapi/dev/reference/get_groups.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(connectapi)
client <- connect()

# Get a data frame of groups
groups <- get_groups(client)

# Get permissions for a single group by passing in the corresponding row.
get_group_content(client, groups[1, "guid"])
dplyr::filter(groups, name = "research_scientists") %>%
  dplyr::pull(guid) %>%
  get_group_content(client, .)

# Get permissions for all groups by passing in all group guids.
get_group_content(client, groups$guid)
} # }
```
