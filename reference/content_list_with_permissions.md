# Get Content List with Permissions

**\[experimental\]** These functions are experimental placeholders until
the API supports this behavior.

## Usage

``` r
content_list_with_permissions(src, ..., .p = NULL)

content_list_guid_has_access(content_list, guid)
```

## Arguments

- src:

  A Connect R6 object

- ...:

  Extra arguments. Currently not used

- .p:

  Optional. A predicate function, passed as-is to
  [`purrr::keep()`](https://purrr.tidyverse.org/reference/keep.html).
  See
  [`get_content()`](https://posit-dev.github.io/connectapi/reference/get_content.md)
  for more details. Can greatly help performance by reducing how many
  items to get permissions for

- content_list:

  A "content list with permissions" as returned by
  `content_list_with_permissions()`

- guid:

  A user or group GUID to filter the content list by whether they have
  access

## Details

`content_list_with_permissions` loops through content and retrieves
permissions for each item (with a progress bar). This can take a long
time for lots of content! Make sure to use the optional `.p` argument as
a predicate function that filters the content list before it is
transformed.

`content_list_guid_has_access` works with a
`content_list_with_permissions` dataset by checking whether a given GUID
(either user or group) has access to the content by:

- checking if the content has access_type == "all"

- checking if the content has access_type == "logged_in"

- checking if the provided guid is the content owner

- checking if the provided guid is in the list of content permissions
  (in the "permissions" column)
