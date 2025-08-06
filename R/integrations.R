#' List all OAuth integrations on the Connect server
#'
#' @description
#' Retrieve information about all OAuth integrations available to Posit Connect.
#' You must have administrator or publisher privileges to perform this action.
#'
#' @param client A `Connect` R6 client object.
#'
#' @return A list of OAuth integrations. Each integration is a list with the
#'   following elements (all character strings unless indicated otherwise):
#'
#'   * `id`: The internal identifier of this OAuth integration.
#'   * `guid`: The GUID of this OAuth integration.
#'   * `created_time`: The timestamp (RFC3339) indicating when this integration
#'     was created.
#'   * `updated_time`: The timestamp (RFC3339) indicating when this integration
#'     was last updated
#'   * `name`: A descriptive name to identify the OAuth integration.
#'   * `description`: A brief text to describe the OAuth integration.
#'   * `template`: The template used to configure this OAuth integration.
#'   * `auth_type`: The authentication type indicates which OAuth flow is used by
#'     this integration.
#'   * `config`: A list with the OAuth integration configuration. Fields
#'     differ between integrations.
#'
#' Use [as.data.frame()] or [tibble::as_tibble()] to convert to a data frame with
#' parsed types. In the resulting data frame:
#'
#'   * `created_time` and `updated_time` are parsed to `POSIXct`.
#'   * `config` remains as a list-column.
#'
#' @seealso [get_oauth_credentials()], [get_oauth_content_credentials()],
#' [get_integration()]
#'
#' @examples
#' \dontrun{
#' client <- connect()
#'
#' # Fetch all OAuth integrations
#' integrations <- get_integrations(client)
#'
#'
#' # Update the configuration and metadata for a subset of integrations.
#' json_payload <- toJSON(list(
#'   description = "New Description",
#'   config = list(
#'     client_secret = "new-client-secret"
#'   )
#' ), auto_unbox = TRUE)
#'
#' results <- integrations |>
#'   purrr::keep(\(x) x$template == "service_to_update") |>
#'   purrr::map(\(x) client$PATCH(paste0("v1/oauth/integrations/", x$guid), body = json_payload))
#'
#'
#' # Convert to tibble or data frame
#' integrations_df <- tibble::as_tibble(integrations)
#' }
#'
#' @family oauth integration functions
#' @export
get_integrations <- function(client) {
  validate_R6_class(client, "Connect")
  error_if_less_than(client$version, "2024.12.0")
  integrations <- client$GET(v1_url("oauth", "integrations"))
  integrations <- purrr::map(integrations, ~ as_integration(.x, client))
  integrations
}

#' Convert integrations list to a data frame
#'
#' @description
#' Converts an list returned by [get_integrations()] into a data frame.
#'
#' @param x A `connect_list_integrations` object (from [get_integrations()]).
#' @param row.names Passed to [base::as.data.frame()].
#' @param optional Passed to [base::as.data.frame()].
#' @param ... Passed to [base::as.data.frame()].
#'
#' @return A `data.frame` with one row per integration.
#' @export
as.data.frame.connect_list_integrations <- function(
  x,
  row.names = NULL, # nolint
  optional = FALSE,
  ...
) {
  integrations_tbl <- as_tibble(x)
  as.data.frame(
    integrations_tbl,
    row.names = row.names,
    optional = optional,
    ...
  )
}

#' Convert integrations list to a tibble
#'
#' @description
#' Converts a list returned by [get_integrations()] to a tibble.
#'
#' @param x A `connect_list_integrations` object.
#' @param ... Unused.
#'
#' @return A tibble with one row per integration.
#' @export
as_tibble.connect_list_integrations <- function(x, ...) {
  parse_connectapi_typed(x, connectapi_ptypes$integrations)
}

# Integration class ----

#' Convert objects to integration class
#'
#' @param x An object to convert to an integration
#' @param client The Connect client object where the integration comes from.
#'
#' @return An integration object. The object has all the fields from the
#' integrations endpoint (see [get_integrations()]) and a Connect client as a
#' `client` attribute (`attr(x, "client")`)
as_integration <- function(x, ...) {
  UseMethod("as_integration")
}

#' @export
as_integration.default <- function(x, ...) {
  stop(
    "Cannot convert object of class '",
    class(x)[1],
    "' to an integration"
  )
}

#' @export
as_integration.list <- function(x, client, ...) {
  structure(x, class = c("connect_integration", "list"), client = client)
}

#' @export
print.connect_integration <- function(x, ...) {
  cat("Integration:", x$name, "\n")
  cat("GUID:", x$guid, "\n")
  cat("Template:", x$template, "\n")
  invisible(x)
}

#' Get the details of an OAuth integration
#'
#' @description
#' Given the GUID of an OAuth integration available on a Connect server, retrieve
#' its details. You must have administrator or publisher privileges to perform
#' this action.
#'
#' @param client A `Connect` R6 client object.
#' @param guid The GUID of an integration available on the Connect server.
#'
#' @return A `connect_integration` object representing an OAuth integration,
#' which has the following fields:
#'
#'   * `id`: The internal identifier of this OAuth integration.
#'   * `guid`: The GUID of this OAuth integration.
#'   * `created_time`: The timestamp (RFC3339) indicating when this integration
#'     was created.
#'   * `updated_time`: The timestamp (RFC3339) indicating when this integration
#'     was last updated
#'   * `name`: A descriptive name to identify the OAuth integration.
#'   * `description`: A brief text to describe the OAuth integration.
#'   * `template`: The template used to configure this OAuth integration.
#'   * `auth_type`: The authentication type indicates which OAuth flow is used by
#'     this integration.
#'   * `config`: A list with the OAuth integration configuration. Fields
#'     differ between integrations.
#'
#' @seealso [get_oauth_credentials()], [get_oauth_content_credentials()], [get_integrations()]
#'
#' @examples
#' \dontrun{
#' client <- connect()
#' x <- get_integration(client, guid)
#' }
#'
#' @family oauth integration functions
#' @export
get_integration <- function(client, guid) {
  validate_R6_class(client, "Connect")
  as_integration(client$GET(v1_url("oauth", "integrations", guid)), client)
}


# Manage integrations ----

#' Create an OAuth integration
#'
#' @description
#' Creates a new OAuth integration on the Posit Connect server. OAuth integrations
#' allow content to access external resources using OAuth credentials.
#' You must have administrator privileges to perform this action.
#'
#' @param client A `Connect` R6 client object.
#' @param name A descriptive name to identify the integration.
#' @param description Optional, default `NULL.` A brief description of the integration.
#' @param template The template to use to configure this integration (e.g.,
#'   "custom", "github", "google", "connect").
#' @param config A list containing the configuration for the integration. The
#'   required fields vary depending on the template selected.
#'
#' @return A `connect_integration` object representing the newly created
#'   integration. See [get_integration()] for details on the returned object.
#'
#' @seealso [get_integrations()], [get_integration()], [update_integration()],
#'   [delete_integration()]
#'
#' @examples
#' \dontrun{
#' client <- connect()
#'
#' # Create a GitHub OAuth integration
#' github_integration <- create_integration(
#'   client,
#'   name = "GitHub Integration",
#'   description = "Integration with GitHub for OAuth access",
#'   template = "github",
#'   config = list(
#'     client_id = "your-client-id",
#'     client_secret = "your-client-secret"
#'   )
#' )
#'
#' # Create a custom OAuth integration
#' custom_integration <- create_integration(
#'   client,
#'   name = "Custom API Integration",
#'   description = "Integration with our custom API",
#'   template = "custom",
#'   config = list(
#'     auth_mode = "Confidential",
#'     auth_type = "Viewer",
#'     authorization_uri = "https://api.example.com/oauth/authorize",
#'     client_id = "your-client-id",
#'     client_secret = "your-client-secret",
#'     token_uri = "https://api.example.com/oauth/token"
#'   )
#' )
#' }
#'
#' @family oauth integration functions
#' @export
create_integration <- function(
  client,
  name,
  description = NULL,
  template,
  config
) {
  validate_R6_class(client, "Connect")
  error_if_less_than(client$version, "2024.12.0")
  result <- client$POST(
    v1_url("oauth", "integrations"),
    body = list(
      name = name,
      description = description,
      template = template,
      config = config
    )
  )
  as_integration(result, client)
}

#' Update an OAuth integration
#'
#' @description
#' Updates an existing OAuth integration. All fields except `integration` are optional,
#' and are unchanged if not provided.
#' You must have administrator privileges to perform this action.
#'
#' @param integration A `connect_integration` object (as returned by [get_integrations()],
#'   [get_integration()], or [create_integration()]).
#' @param name A new name for the integration.
#' @param description A new description for the integration.
#' @param template The template to use (generally not changed after creation).
#' @param config A list with updated OAuth integration configuration. If `NULL`
#'   (default), the configuration remains unchanged. You can update individual
#'   configuration fields without affecting others.
#'
#' @return A `connect_integration` object representing the updated OAuth
#'   integration. See [get_integration()] for details on the returned object.
#'
#' @seealso [get_integrations()], [get_integration()], [create_integration()],
#'   [delete_integration()]
#'
#' @examples
#' \dontrun{
#' client <- connect()
#'
#' # Get an existing integration
#' integration <- get_integration(client, "your-integration-guid")
#'
#' # Update the integration's name and description
#' updated_integration <- update_integration(
#'   integration,
#'   name = "Updated GitHub Integration",
#'   description = "A more descriptive description."
#' )
#'
#' # Update only the client secret in the configuration
#' updated_integration <- update_integration(
#'   integration,
#'   config = list(
#'     client_secret = "your-new-client-secret"
#'   )
#' )
#' }
#'
#' @family oauth integration functions
#' @export
update_integration <- function(
  integration,
  name = NULL,
  description = NULL,
  template = NULL,
  config = NULL
) {
  if (!inherits(integration, "connect_integration")) {
    stop("'integration' must be a 'connect_integration' object")
  }
  client <- attr(integration, "client")
  validate_R6_class(client, "Connect")
  error_if_less_than(client$version, "2024.12.0")
  result <- client$PATCH(
    v1_url("oauth", "integrations", integration$guid),
    body = list(
      name = name,
      description = description,
      template = template,
      config = config
    )
  )
  as_integration(result, client)
}

#' Delete an OAuth integration
#'
#' @description
#' Deletes an OAuth integration from the Posit Connect server. This permanently
#' removes the integration and any associated content associations.
#' You must have administrator privileges to perform this action.
#'
#' @param integration A `connect_integration` object (as returned by [get_integrations()],
#'   [get_integration()], or [create_integration()]).
#'
#' @return Returns `NULL` invisibly if successful.
#'
#' @seealso [get_integrations()], [get_integration()], [create_integration()],
#'   [update_integration()]
#'
#' @examples
#' \dontrun{
#' client <- connect()
#'
#' # Get an integration to delete
#' integration <- get_integration(client, "your-integration-guid")
#'
#' # Delete the integration
#' delete_integration(integration)
#' }
#'
#' @family oauth integration functions
#' @export
delete_integration <- function(integration) {
  if (!inherits(integration, "connect_integration")) {
    stop("'integration' must be a 'connect_integration' object")
  }
  client <- attr(integration, "client")
  validate_R6_class(client, "Connect")
  error_if_less_than(client$version, "2024.12.0")
  client$DELETE(v1_url("oauth", "integrations", integration$guid))
  invisible(NULL)
}
