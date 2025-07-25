% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connect.R
\name{connect}
\alias{connect}
\title{Create a connection to Posit Connect}
\usage{
connect(
  server = Sys.getenv(paste0(prefix, "_SERVER"), NA_character_),
  api_key = Sys.getenv(paste0(prefix, "_API_KEY"), NA_character_),
  token,
  token_local_testing_key = api_key,
  prefix = "CONNECT",
  audience = NULL,
  ...,
  .check_is_fatal = TRUE
)
}
\arguments{
\item{server}{The URL for accessing Posit Connect. Defaults to environment
variable CONNECT_SERVER}

\item{api_key}{The API Key to authenticate to Posit Connect with. Defaults
to environment variable CONNECT_API_KEY}

\item{token}{Optional. A user session token. When running on a Connect server,
creates a client using the content visitor's account. Running locally, the
created client uses the provided API key.}

\item{token_local_testing_key}{Optional. Only used when not running on
Connect and a \code{token} is provided. By default, the function returns a
\code{Connect} object using the \code{api_key}. By providing a different
key here you can test a visitor client with differently-scoped
permissions.}

\item{prefix}{The prefix used to determine environment variables}

\item{audience}{Optional. The GUID of a Connect API integration associated with this piece of content.}

\item{...}{Additional arguments. Not used at present}

\item{.check_is_fatal}{Whether to fail if "check" requests fail. Useful in
rare cases where more http request customization is needed for requests to
succeed.}
}
\value{
A Posit Connect R6 object that can be passed along to methods
}
\description{
Creates a connection to Posit Connect using the server URL and an API key.
Validates the connection and checks that the version of the server is
compatible with the current version of the package.
}
\details{
When running on Connect, the client's environment will contain default
\code{CONNECT_SERVER} and \code{CONNECT_API_KEY} variables. The API key's permissions
are scoped to the publishing user's account.

To create a client with permissions scoped to the content visitor's account,
call \code{connect()} passing a user session token from content session headers
to the \code{token} argument. To do this, you must first add a Connect API
integration in your published content's Access sidebar.
}
\examples{
\dontrun{
client <- connect()

# Running in Connect, create a client using the content visitor's account.
# This example assumes code is being executed in a Shiny app's `server`
# function with a `session` object available.
token <- session$request$HTTP_POSIT_CONNECT_USER_SESSION_TOKEN
client <- connect(token = token)

# Test locally with an API key using a different role.
fallback_key <- Sys.getenv("VIEWER_ROLE_API_KEY")
client <- connect(token = token, token_local_testing_key = fallback_key)
}

\dontshow{if (identical(Sys.getenv("IN_PKGDOWN"), "true")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# default is to read CONNECT_SERVER and CONNECT_API_KEY environment variables
# this example will read TEST_1_SERVER and TEST_1_API_KEY
connect(prefix = "TEST_1")
\dontshow{\}) # examplesIf}
}
