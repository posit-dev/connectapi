# User

Get user details

## Usage

``` r
user_guid_from_username(client, username)
```

## Arguments

- client:

  A Connect R6 object

- username:

  The user's username

## Details

`user_guid_from_username()` is a helper to retrieve a user GUID, given
the user's username. It is useful in Shiny applications for using
`session$user`
