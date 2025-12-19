# Delete an OAuth integration

Deletes an OAuth integration from the Posit Connect server. This
permanently removes the integration and any associated content
associations.

You must have administrator privileges to perform this action.

See the Posit Connect documentation on [OAuth
integrations](https://docs.posit.co/connect/admin/integrations/oauth-integrations/)
for more information.

## Usage

``` r
delete_integration(integration)
```

## Arguments

- integration:

  A `connect_integration` object (as returned by
  [`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
  [`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md),
  or
  [`create_integration()`](https://posit-dev.github.io/connectapi/dev/reference/create_integration.md)).

## Value

Returns `NULL` invisibly if successful.

## See also

[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md),
[`create_integration()`](https://posit-dev.github.io/connectapi/dev/reference/create_integration.md),
[`update_integration()`](https://posit-dev.github.io/connectapi/dev/reference/update_integration.md)

Other oauth integration functions:
[`create_integration()`](https://posit-dev.github.io/connectapi/dev/reference/create_integration.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/dev/reference/get_associations.md),
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md),
[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/set_integrations.md),
[`update_integration()`](https://posit-dev.github.io/connectapi/dev/reference/update_integration.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()

# Get an integration to delete
integration <- get_integration(client, "your-integration-guid")

# Delete the integration
delete_integration(integration)
} # }
```
