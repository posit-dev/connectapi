# Create an OAuth integration

Creates a new OAuth integration on the Posit Connect server. OAuth
integrations allow content to access external resources using OAuth
credentials.

You must have administrator privileges to perform this action.

See the Posit Connect documentation on [OAuth
integrations](https://docs.posit.co/connect/admin/integrations/oauth-integrations/)
for more information.

## Usage

``` r
create_integration(client, name, description = NULL, template, config)
```

## Arguments

- client:

  A `Connect` R6 client object.

- name:

  A descriptive name to identify the integration.

- description:

  Optional, default `NULL.` A brief description of the integration.

- template:

  The template to use to configure this integration (e.g., "custom",
  "github", "google", "connect").

- config:

  A list containing the configuration for the integration. The required
  fields vary depending on the template selected.

## Value

A `connect_integration` object representing the newly created
integration. See
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md)
for details on the returned object.

## See also

[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md),
[`update_integration()`](https://posit-dev.github.io/connectapi/dev/reference/update_integration.md),
[`delete_integration()`](https://posit-dev.github.io/connectapi/dev/reference/delete_integration.md)

Other oauth integration functions:
[`delete_integration()`](https://posit-dev.github.io/connectapi/dev/reference/delete_integration.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/dev/reference/get_associations.md),
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md),
[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/set_integrations.md),
[`update_integration()`](https://posit-dev.github.io/connectapi/dev/reference/update_integration.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()

# Create a GitHub OAuth integration
github_integration <- create_integration(
  client,
  name = "GitHub Integration",
  description = "Integration with GitHub for OAuth access",
  template = "github",
  config = list(
    client_id = "your-client-id",
    client_secret = "your-client-secret"
  )
)

# Create a custom OAuth integration
custom_integration <- create_integration(
  client,
  name = "Custom API Integration",
  description = "Integration with our custom API",
  template = "custom",
  config = list(
    auth_mode = "Confidential",
    auth_type = "Viewer",
    authorization_uri = "https://api.example.com/oauth/authorize",
    client_id = "your-client-id",
    client_secret = "your-client-secret",
    token_uri = "https://api.example.com/oauth/token"
  )
)
} # }
```
