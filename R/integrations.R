#' Get OAuth integrations
#'
#' @description
#' Retrieve OAuth integrations either from the Connect server or associated with a specific content item.
#'
#' If `x` is a `Connect` object, this function lists all OAuth integrations on the server.
#' If `x` is a `Content` object, it returns the integrations associated with that content item.
#'
#' You must have administrator or publisher privileges to use this function.
#'
#' @param x A `Connect` or `Content` R6 object.
#'
#' @return A list of class `connect_integration_list`, where each element is a `connect_integration` object
#'   with the following fields (all character strings unless noted otherwise):
#'
#'   * `id`: The internal identifier of this OAuth integration.
#'   * `guid`: The GUID of this OAuth integration.
#'   * `created_time`: Timestamp (RFC3339) when the integration was created.
#'   * `updated_time`: Timestamp (RFC3339) when the integration was last updated.
#'   * `name`: A descriptive name.
#'   * `description`: A brief description.
#'   * `template`: The template used to configure the integration.
#'   * `auth_type`: The OAuth flow used.
#'   * `config`: A list with integration-specific config fields.
#'
#' Use [as.data.frame()] or [tibble::as_tibble()] to convert the result to a data frame with parsed types.
#'
#' @seealso [get_integration()], [set_integrations()]
#'
#' @examples
#' \dontrun{
#' # From a Connect client
#' client <- connect()
#' integrations <- get_integrations(client)
#'
#' # Filter or update specific ones
#' github_integration <- purrr::keep(integrations, \(x) x$template == "github")[[1]]
#'
#' json_payload <- jsonlite::toJSON(list(
#'   description = "Updated Description",
#'   config = list(client_secret = "new-secret")
#' ), auto_unbox = TRUE)
#'
#' client$PATCH(
#'   paste0("v1/oauth/integrations/", github_integration$guid),
#'   body = json_payload
#' )
#'
#' # From a Content item
#' content <- content_item(client, "12345678-90ab-cdef-1234-567890abcdef")
#' content_integrations <- get_integrations(content)
#'
#' # Filter content integrations
#' snowflake_integrations <- purrr::keep(content_integrations, ~ .x$template == "snowflake")
#' }
#'
#' @export
get_integrations <- function(x) {
  if (inherits(x, "Connect")) {
    error_if_less_than(x$version, "2024.12.0")
    integrations <- x$GET(v1_url("oauth", "integrations"))
    integrations <- lapply(integrations, as_integration)
  } else if (inherits(x, "Content")) {
    error_if_less_than(x$connect$version, "2024.12.0")
    assoc <- x$connect$GET(v1_url(
      "content",
      x$content$guid,
      "oauth",
      "integrations",
      "associations"
    ))
    integrations <- purrr::map(
      assoc,
      ~ get_integration(x$connect, .x$oauth_integration_guid)
    )
  } else {
    stop("`x` must be a Connect or Content object.")
  }

  class(integrations) <- c("connect_integration_list", class(integrations))
  integrations
}

#' Convert integrations list to a data frame
#'
#' @description
#' Converts an list returned by [get_integrations()] into a data frame.
#'
#' @param x A `connect_integration_list` object (from [get_integrations()]).
#' @param row.names Passed to [base::as.data.frame()].
#' @param optional Passed to [base::as.data.frame()].
#' @param ... Passed to [base::as.data.frame()].
#'
#' @return A `data.frame` with one row per integration.
#' @export
as.data.frame.connect_integration_list <- function(
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

#' Convert integration list to a tibble
#'
#' @description
#' Converts a list returned by [get_integrations()] to a tibble.
#'
#' @param x A `connect_integration_list` object.
#' @param ... Unused.
#'
#' @return A tibble with one row per integration.
#' @export
as_tibble.connect_integration_list <- function(x, ...) {
  parse_connectapi_typed(x, connectapi_ptypes$integrations)
}

# Integration class ----

#' Convert objects to integration class
#'
#' @param x An object to convert to an integration.
#' @param ... Unused.
#'
#' @return An integration object
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
  structure(x, class = c("connect_integration", "list"))
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
  as_integration(client$GET(v1_url("oauth", "integrations", guid)))
}

# Get and set integrations on content

#' Set all OAuth integrations for a content item
#'
#' @description
#' Removes all existing OAuth integrations associated with a content item, and
#' creates associations with the integrations provided. You must have
#' administrator or publisher privileges to perform this action.
#'
#' @param content A `Content` R6 object representing the content item to modify.
#' @param integrations The complete set of integrations to be associated with the
#'   content. May be a single `connect_integration` object, a list of
#'   `connect_integration` objects, or `NULL`. Passing in an empty list or
#'   explicitly passing `NULL` will remove all associated integrations from the
#'   content.
#'
#' @return Invisibly returns `NULL`.
#'
#' @seealso
#' [get_integrations()], [get_integration()], [content_item()]
#'
#' @examples
#' \dontrun{
#' client <- connect()
#'
#' content <- content_item(client, "12345678-90ab-cdef-1234-567890abcdef")
#'
#' integrations <- get_integrations(client)
#'
#' # Associate a single integration
#' github_integration <- purrr::keep(integrations, \(x) x$template == "github")[[1]]
#' set_integrations(content, github_integration)
#'
#' # Associate multiple integrations at once
#' selected_integrations <- integrations[1:2]
#' set_integrations(content, selected_integrations)
#'
#' # Unset integrations
#' set_integrations(content, NULL)
#' }
#'
#' @family oauth integration functions
#' @family content functions
#' @export
set_integrations <- function(content, integrations) {
  validate_R6_class(content, "Content")
  # Handle a single integration
  if (inherits(integrations, "connect_integration")) {
    integrations <- list(integrations)
  } else if (!is.null(integrations) && !inherits(integrations, "list")) {
    stop(
      "`integrations` must be a `connect_integration` class object, a list, ",
      "or NULL."
    )
  }
  # Ensure that all the items we've been passed are integrations
  if (!purrr::every(integrations, ~ inherits(.x, "connect_integration"))) {
    stop("All items must be `connect_integration` objects")
  }

  payload <- purrr::map(integrations, ~ list(oauth_integration_guid = .x$guid))

  content$connect$PUT(
    v1_url(
      "content",
      content$content$guid,
      "oauth",
      "integrations",
      "associations"
    ),
    body = payload
  )
  invisible(NULL)
}
