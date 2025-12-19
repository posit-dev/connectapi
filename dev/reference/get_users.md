# Get user information from the Posit Connect server

Get user information from the Posit Connect server

## Usage

``` r
get_users(
  src,
  page_size = 500,
  prefix = NULL,
  limit = Inf,
  user_role = NULL,
  account_status = NULL
)
```

## Arguments

- src:

  The source object

- page_size:

  the number of records to return per page (max 500)

- prefix:

  Filters users by prefix (username, first name, or last name). The
  filter is case insensitive.

- limit:

  The max number of records to return

- user_role:

  Optionally filter by user role ("administrator", "publisher",
  "viewer"). Pass in a vector of multiple roles to match any value
  (boolean OR). When `NULL` (the default), results are not filtered.

- account_status:

  Optionally filter by account status ("locked", "licensed",
  "inactive"). Pass a vector of multiple statuses to match any value
  (boolean OR). When `NULL` (the default), results are not filtered.

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

Please see https://docs.posit.co/connect/api/#get-/v1/users for more
information.

## Examples

``` r
if (FALSE) { # \dontrun{
library(connectapi)
client <- connect()

# Get all users
get_users(client)

# Get all licensed users
get_users(client, account_status = "licensed")

# Get all users who are administrators or publishers
get_users(client, user_role = c("administrator", "publisher"))
} # }
```
