# Update an OAuth integration

Updates an existing OAuth integration. All fields except `integration`
are optional, and are unchanged if not provided.

You must have administrator privileges to perform this action.

See the Posit Connect documentation on [OAuth
integrations](https://docs.posit.co/connect/admin/integrations/oauth-integrations/)
for more information.

## Usage

``` r
update_integration(
  integration,
  name = NULL,
  description = NULL,
  template = NULL,
  config = NULL
)
```

## Arguments

- integration:

  A `connect_integration` object (as returned by
  [`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
  [`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md),
  or
  [`create_integration()`](https://posit-dev.github.io/connectapi/dev/reference/create_integration.md)).

- name:

  A new name for the integration.

- description:

  A new description for the integration.

- template:

  The template to use (generally not changed after creation).

- config:

  A list with updated OAuth integration configuration. If `NULL`
  (default), the configuration remains unchanged. You can update
  individual configuration fields without affecting others.

## Value

A `connect_integration` object representing the updated OAuth
integration. See
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md)
for details on the returned object.

## See also

[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md),
[`create_integration()`](https://posit-dev.github.io/connectapi/dev/reference/create_integration.md),
[`delete_integration()`](https://posit-dev.github.io/connectapi/dev/reference/delete_integration.md)

Other oauth integration functions:
[`create_integration()`](https://posit-dev.github.io/connectapi/dev/reference/create_integration.md),
[`delete_integration()`](https://posit-dev.github.io/connectapi/dev/reference/delete_integration.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/dev/reference/get_associations.md),
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md),
[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/set_integrations.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()

# Get an existing integration
integration <- get_integration(client, "your-integration-guid")

# Update the integration's name and description
updated_integration <- update_integration(
  integration,
  name = "Updated GitHub Integration",
  description = "A more descriptive description."
)

# Update only the client secret in the configuration
updated_integration <- update_integration(
  integration,
  config = list(
    client_secret = "your-new-client-secret"
  )
)
} # }
```
