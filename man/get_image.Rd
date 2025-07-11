% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/thumbnail.R
\name{get_image}
\alias{get_image}
\alias{delete_image}
\alias{has_image}
\title{Get the Content Image}
\usage{
get_image(content, path = NULL)

delete_image(content, path = NULL)

has_image(content)
}
\arguments{
\item{content}{A content object}

\item{path}{optional. The path to the image on disk}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}

Please use \code{\link{get_thumbnail}},
\code{\link{delete_thumbnail}}, and \code{\link{has_thumbnail}} instead.

\code{get_image} saves the content image to the given path (default: temp file).
\code{delete_image} removes the image (optionally saving to the given path)
\code{has_image} returns whether the content has an image
}
\seealso{
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
\code{\link{get_job}()},
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
