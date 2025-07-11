% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/content.R
\name{get_job}
\alias{get_job}
\title{Retrieve details about a server process
associated with a \code{content_item}, such as a FastAPI app or a Quarto render.}
\usage{
get_job(content, key)
}
\arguments{
\item{content}{A Content object, as returned by \code{content_item()}}

\item{key}{The key for a job}
}
\description{
Retrieve details about a server process
associated with a \code{content_item}, such as a FastAPI app or a Quarto render.
}
\seealso{
Other job functions: 
\code{\link{get_jobs}()},
\code{\link{get_log}()},
\code{\link{terminate_jobs}()}

Other content functions: 
\code{\link{content_delete}()},
\code{\link{content_item}()},
\code{\link{content_title}()},
\code{\link{content_update}()},
\code{\link{create_random_name}()},
\code{\link{dashboard_url}()},
\code{\link{delete_thumbnail}()},
\code{\link{delete_vanity_url}()},
\code{\link{deploy_repo}()},
\code{\link{get_bundles}()},
\code{\link{get_environment}()},
\code{\link{get_image}()},
\code{\link{get_jobs}()},
\code{\link{get_log}()},
\code{\link{get_thumbnail}()},
\code{\link{get_vanity_url}()},
\code{\link{git}},
\code{\link{has_thumbnail}()},
\code{\link{permissions}},
\code{\link{set_image_path}()},
\code{\link{set_run_as}()},
\code{\link{set_thumbnail}()},
\code{\link{set_vanity_url}()},
\code{\link{swap_vanity_url}()},
\code{\link{swap_vanity_urls}()},
\code{\link{terminate_jobs}()},
\code{\link{verify_content_name}()}
}
\concept{content functions}
\concept{job functions}
