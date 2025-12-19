# Get the details of an OAuth integration

Given the GUID of an OAuth integration available on a Connect server,
retrieve its details. You must have administrator or publisher
privileges to perform this action.

## Usage

``` r
get_integration(client, guid)
```

## Arguments

- client:

  A `Connect` R6 client object.

- guid:

  The GUID of an integration available on the Connect server.

## Value

A `connect_integration` object representing an OAuth integration, which
has the following fields:

- `id`: The internal identifier of this OAuth integration.

- `guid`: The GUID of this OAuth integration.

- `created_time`: The timestamp (RFC3339) indicating when this
  integration was created.

- `updated_time`: The timestamp (RFC3339) indicating when this
  integration was last updated

- `name`: A descriptive name to identify the OAuth integration.

- `description`: A brief text to describe the OAuth integration.

- `template`: The template used to configure this OAuth integration.

- `auth_type`: The authentication type indicates which OAuth flow is
  used by this integration.

- `config`: A list with the OAuth integration configuration. Fields
  differ between integrations.

## See also

[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/dev/reference/get_associations.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/set_integrations.md)

Other oauth integration functions:
[`create_integration()`](https://posit-dev.github.io/connectapi/dev/reference/create_integration.md),
[`delete_integration()`](https://posit-dev.github.io/connectapi/dev/reference/delete_integration.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/dev/reference/get_associations.md),
[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/set_integrations.md),
[`update_integration()`](https://posit-dev.github.io/connectapi/dev/reference/update_integration.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()
x <- get_integration(client, guid)
} # }
```
