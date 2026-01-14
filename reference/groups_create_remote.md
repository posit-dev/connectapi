# Create a Remote Group

Create a Remote Group

## Usage

``` r
groups_create_remote(connect, prefix, expect = 1, check = TRUE, exact = FALSE)
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

  boolean. Optional. Whether to only create groups whose name exactly
  matches the provided `prefix`.

## Value

The results of creating the groups.
