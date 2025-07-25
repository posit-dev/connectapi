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
#' Converts an object returned by [get_integrations()] into a data frame with parsed
#' column types.
#'
#' @param x A `connect_list_integrations` object (from [get_integrations()]).
#' @param row.names Passed to [base::as.data.frame()].
#' @param optional Passed to [base::as.data.frame()].
#' @param ... Passed to [base::as.data.frame()].
#'
#' @return A `data.frame` with one row per integration.
#' @export
#' @method as.data.frame connect_list_integrations
as.data.frame.connect_list_integrations <- function(
  x,
  row.names = NULL,
  optional = FALSE,
  ...
) {
  integrations_df <- parse_connectapi_typed(x, connectapi_ptypes$integrations)
  as.data.frame(
    integrations_df,
    row.names = row.names,
    optional = optional,
    ...
  )
}

#' Convert integrations data to a tibble
#'
#' @description
#' Converts an object returned by [get_integrations()] to a tibble via
#' [as.data.frame.connect_list_integrations()].
#'
#' @param x A `connect_list_integrations` object.
#' @param ... Passed to [as.data.frame()].
#'
#' @return A tibble with one row per integration.
#' @export
#' @importFrom tibble as_tibble
#' @method as_tibble connect_list_integrations
as_tibble.connect_list_integrations <- function(x, ...) {
  tibble::as_tibble(as.data.frame(x, ...))
}
