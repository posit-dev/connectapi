# Get OAuth integrations

Retrieve OAuth integrations either from the Connect server or associated
with a specific content item.

If `x` is a `Connect` object, this function lists all OAuth integrations
on the server. If `x` is a `Content` object, it returns the integrations
associated with that content item.

You must have administrator or publisher privileges to use this
function.

## Usage

``` r
get_integrations(x)
```

## Arguments

- x:

  A `Connect` or `Content` R6 object.

## Value

A list of class `connect_integration_list`, where each element is a
`connect_integration` object with the following fields. (Raw API fields
are character strings unless noted otherwise):

- `id`: The internal identifier of this OAuth integration.

- `guid`: The GUID of this OAuth integration.

- `created_time`: Timestamp (RFC3339) when the integration was created.

- `updated_time`: Timestamp (RFC3339) when the integration was last
  updated.

- `name`: A descriptive name.

- `description`: A brief description.

- `template`: The template used to configure the integration.

- `auth_type`: The OAuth flow used.

- `config`: A list with integration-specific config fields.

Use [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) or
[`tibble::as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html)
to convert the result to a data frame with parsed types.

## See also

[`get_integration()`](https://posit-dev.github.io/connectapi/reference/get_integration.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/reference/set_integrations.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/reference/get_associations.md)

Other oauth integration functions:
[`create_integration()`](https://posit-dev.github.io/connectapi/reference/create_integration.md),
[`delete_integration()`](https://posit-dev.github.io/connectapi/reference/delete_integration.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/reference/get_associations.md),
[`get_integration()`](https://posit-dev.github.io/connectapi/reference/get_integration.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/reference/set_integrations.md),
[`update_integration()`](https://posit-dev.github.io/connectapi/reference/update_integration.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# From a Connect client
client <- connect()
integrations <- get_integrations(client)

# Filter or update specific ones
github_integration <- purrr::keep(integrations, \(x) x$template == "github")[[1]]

json_payload <- jsonlite::toJSON(list(
  description = "Updated Description",
  config = list(client_secret = "new-secret")
), auto_unbox = TRUE)

client$PATCH(
  paste0("v1/oauth/integrations/", github_integration$guid),
  body = json_payload
)

# From a Content item
content <- content_item(client, "12345678-90ab-cdef-1234-567890abcdef")
content_integrations <- get_integrations(content)

# Filter content integrations
snowflake_integrations <- purrr::keep(content_integrations, ~ .x$template == "snowflake")
} # }
```
