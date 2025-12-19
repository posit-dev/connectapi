# Perform an OAuth credential exchange to obtain a visitor's OAuth access token.

Perform an OAuth credential exchange to obtain a visitor's OAuth access
token.

## Usage

``` r
get_oauth_credentials(
  connect,
  user_session_token,
  requested_token_type = NULL,
  audience = NULL
)
```

## Arguments

- connect:

  A Connect R6 object.

- user_session_token:

  The content visitor's session token. This token can only be obtained
  when the content is running on a Connect server. The token identifies
  the user who is viewing the content interactively on the Connect
  server. Read this value from the HTTP header:
  `Posit-Connect-User-Session-Token`

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
https://docs.posit.co/connect/user/oauth-integrations/#obtaining-a-viewer-oauth-access-token
for more information.

## See also

[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`get_oauth_content_credentials()`](https://posit-dev.github.io/connectapi/dev/reference/get_oauth_content_credentials.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(connectapi)
library(plumber)
client <- connect()

#* @get /do
function(req) {
  user_session_token <- req$HTTP_POSIT_CONNECT_USER_SESSION_TOKEN
  credentials <- get_oauth_credentials(client, user_session_token)

  # ... do something with `credentials$access_token` ...

  "done"
}
} # }
```
