% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get.R
\name{get_packages}
\alias{get_packages}
\title{All package dependencies on the server}
\usage{
get_packages(src, name = NULL, page_size = 100000, limit = Inf)
}
\arguments{
\item{src}{A \code{Connect} client object.}

\item{name}{Optional package name to filter by. Python package are normalized
during matching; R package names must match exactly.}

\item{page_size}{Optional. Integer specifying page size for API
paging.}

\item{limit}{Optional. Specify the maximum number of records after which
to cease paging.}
}
\value{
A data frame with the following columns:
\itemize{
\item \code{language}: Language ecosystem the package belongs to (\code{r} or \code{python})
\item \code{language_version}: Version of R or Python used by the content
\item \code{name}: Package name
\item \code{version}: Package version
\item \code{hash}: Package description hash for R packages
\item \code{bundle_id}: Identifier for the bundle that depends on this package
\item \code{content_id}: Numeric identifier for the content that depends on this
package
\item \code{content_guid}: The unique identifier of the content item that depends on
this package
}
}
\description{
Get a data frame of package dependencies used by all content
items on the server.
}
\examples{
\dontrun{
client <- connect()
packages <- get_packages(client)
}

}
\seealso{
Other packages functions: 
\code{\link{get_content_packages}()}
}
\concept{packages functions}
