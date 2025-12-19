# Create a Remote User

The remote user creation workflow involves authentication providers like
LDAP that involve a queryable identity store. This helper wraps the API
calls necessary to retrieve information about and then create such a
user. It functions with a "fuzzy match" `prefix` by default, but if you
want to instantiate users directly, you should set `exact = TRUE`.

## Usage

``` r
users_create_remote(connect, prefix, expect = 1, check = TRUE, exact = FALSE)
```

## Arguments

- connect:

  An R6 Connect object.

- prefix:

  character. The prefix of the user name to search for.

- expect:

  number. Optional. The number of responses to expect for this search.

- check:

  boolean. Optional. Whether to check for local existence first.

- exact:

  boolean. Optional. Whether to only create users whose username exactly
  matches the provided `prefix`.

## Value

The results of creating the users.

## Details

NOTE: there can be problems with usernames that are not unique. Please
open an issue if you run into any problems.
