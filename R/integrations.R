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
#' @seealso [get_oauth_credentials()], [get_oauth_content_credentials()], [integration()]
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
  error_if_less_than(client$version, "2024.12.0")
  integrations <- client$GET(v1_url("oauth", "integrations"))
  integrations <- lapply(integrations, as_integration)
  class(integrations) <- c("connect_list_integrations", class(integrations))
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

validate_integration <- function(x) {
  fields <- c(
    "id",
    "guid",
    "created_time",
    "updated_time",
    "name",
    "description",
    "template",
    "auth_type",
    "config"
  )
  missing_fields <- setdiff(fields, names(x))
  if (length(missing_fields) > 0) {
    stop("Missing required fields: ", paste(missing_fields, collapse = ","))
  }
}

#' Convert objects to integration class
#'
#' @param x An object to convert to an integration
#' @param ... Additional arguments passed to methods
#'
#' @return An integration object
#' @export
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
as_integration.list <- function(x) {
  y <- structure(x, class = c("connect_integration", "list"))
  validate_integration(y)
  y
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
#' x <- integration(client, guid)
#' }
#'
#' @family oauth integration functions
#' @export
integration <- function(client, guid) {
  validate_R6_class(client, "Connect")
  as_integration(client$GET(v1_url("oauth", "integrations", guid)))
}
