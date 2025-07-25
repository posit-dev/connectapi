% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get.R
\name{get_aws_credentials}
\alias{get_aws_credentials}
\title{Obtain a visitor's AWS credentials}
\usage{
get_aws_credentials(connect, user_session_token, audience = NULL)
}
\arguments{
\item{connect}{A Connect R6 object.}

\item{user_session_token}{The content visitor's session token. This token
can only be obtained when the content is running on a Connect server. The token
identifies the user who is viewing the content interactively on the Connect server.
Read this value from the HTTP header: \code{Posit-Connect-User-Session-Token}}

\item{audience}{Optional. The GUID of an OAuth integration associated with
this piece of content.}
}
\value{
The AWS credentials as a list with fields named \code{access_key_id},
\code{secret_access_key}, \code{session_token}, and \code{expiration}.
}
\description{
Obtain a visitor's AWS credentials
}
\details{
Please see https://docs.posit.co/connect/user/oauth-integrations/#obtaining-service-account-aws-credentials
for more information. See the example below of using this function in a
Plumber API with paws to access S3. Any library that allows you to pass
AWS credentials will be able to utilize the credentials returned from
this function call.
}
\examples{
\dontrun{
library(connectapi)
library(plumber)
library(paws)
client <- connect()

#* @get /do
function(req) {
  user_session_token <- req$HTTP_POSIT_CONNECT_USER_SESSION_TOKEN
  aws_credentials <- get_aws_credentials(client, user_session_token)

  # Create S3 client with AWS credentials from Connect
  svc <- paws::s3(
    credentials = list(
      creds = list(
        access_key_id = aws_credentials$access_key_id,
        secret_access_key = aws_credentials$secret_access_key,
        session_token = aws_credentials$session_token
      )
    )
  )

  # Get object from S3
  obj <- svc$get_object(
    Bucket = "my-bucket",
    Key = "my-data.csv"
  )

  "done"
}
}

}
