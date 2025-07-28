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
#'   * `config`: A sub-list list with the OAuth integration configuration. Fields
#'     differ between integrations.
#'
#' Use [as.data.frame()] or [tibble::as_tibble()] to convert to a data frame with
#' parsed types. In the resulting data frame:
#'
#'   * `created_time` and `updated_time` are parsed to `POSIXct`.
#'   * `config` remains as a list-column.
#'
#' @seealso [get_oauth_credentials()], [get_oauth_content_credentials()]
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
#' @export
get_integrations <- function(client) {
  error_if_less_than(client$version, "2024.12.0")
  integrations <- client$GET(v1_url("oauth", "integrations"))
  class(integrations) <- c("connect_list_integrations", class(integrations))
  integrations
}

#' Convert integrations data to a data frame
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

#' Convert integrations data to a tibble
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
