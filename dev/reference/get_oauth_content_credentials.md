# Perform an OAuth credential exchange to obtain a content-specific OAuth access token.

Perform an OAuth credential exchange to obtain a content-specific OAuth
access token.

## Usage

``` r
get_oauth_content_credentials(
  connect,
  content_session_token = NULL,
  requested_token_type = NULL,
  audience = NULL
)
```

## Arguments

- connect:

  A Connect R6 object.

- content_session_token:

  Optional. The content session token. This token can only be obtained
  when the content is running on a Connect server. The token identifies
  the service account integration previously configured by the publisher
  on the Connect server. Defaults to the value from the environment
  variable: `CONNECT_CONTENT_SESSION_TOKEN`

- requested_token_type:

  Optional. The requested token type. If unset, will default to
  `urn:ietf:params:oauth:token-type:access_token`. Otherwise, this can
  be set to `urn:ietf:params:aws:token-type:credentials` for AWS
  integrations or `urn:posit:connect:api-key` for Connect API Key
  integrations.

- audience:

  Optional. The GUID of an OAuth integration associated with this piece
  of content.

## Value

The OAuth credential exchange response.

## Details

Please see
https://docs.posit.co/connect/user/oauth-integrations/#obtaining-a-service-account-oauth-access-token
for more information.

## See also

[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`get_oauth_credentials()`](https://posit-dev.github.io/connectapi/dev/reference/get_oauth_credentials.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(connectapi)
library(plumber)
client <- connect()

#* @get /do
function(req) {
  credentials <- get_oauth_content_credentials(client)

  # ... do something with `credentials$access_token` ...

  "done"
}
} # }
```
