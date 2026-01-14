# Get users within a specific group

Get users within a specific group

## Usage

``` r
get_group_members(src, guid)
```

## Arguments

- src:

  A Connect client object

- guid:

  A group GUID identifier

## Value

A tibble with the following columns:

- `email`: The user's email

- `username`: The user's username

- `first_name`: The user's first name

- `last_name`: The user's last name

- `user_role`: The user's role. It may have a value of administrator,
  publisher or viewer.

- `created_time`: The timestamp (in RFC3339 format) when the user was
  created in the Posit Connect server

- `updated_time`: The timestamp (in RFC3339 format) when the user was
  last updated in the Posit Connect server

- `active_time`: The timestamp (in RFC3339 format) when the user was
  last active on the Posit Connect server

- `confirmed`: When false, the created user must confirm their account
  through an email. This feature is unique to password authentication.

- `locked`: Whether or not the user is locked

- `guid`: The user's GUID, or unique identifier, in UUID RFC4122 format

## Details

Please see
https://docs.posit.co/connect/api/#get-/v1/groups/-group_guid-/members
for more information.

## See also

Other groups functions:
[`get_group_content()`](https://posit-dev.github.io/connectapi/reference/get_group_content.md),
[`get_groups()`](https://posit-dev.github.io/connectapi/reference/get_groups.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(connectapi)
client <- connect()

# get the first 20 groups
groups <- get_groups(client)

group_guid <- groups$guid[1]

get_group_members(client, guid = group_guid)
} # }
```
