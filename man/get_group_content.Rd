% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/groups.R
\name{get_group_content}
\alias{get_group_content}
\title{Get content access permissions for a group or groups}
\usage{
get_group_content(src, guids)
}
\arguments{
\item{src}{A Connect client object}

\item{guids}{A character vector of group guids}
}
\value{
A tibble with the following columns:
\itemize{
\item \code{group_guid}: The group's GUID
\item \code{group_name}: The group's name
\item \code{content_guid}: The content item's GUID
\item \code{content_name}: The content item's name
\item \code{content_title}: The content item's title
\item \code{access_type}: The access type of the content item ("all", "logged_in", or "acl")
\item \code{role}: The access type that members of the group have to the
content item, "publisher" or "viewer".
}
}
\description{
Get content access permissions for a group or groups
}
\examples{
\dontrun{
library(connectapi)
client <- connect()

# Get a data frame of groups
groups <- get_groups(client)

# Get permissions for a single group by passing in the corresponding row.
get_group_content(client, groups[1, "guid"])
dplyr::filter(groups, name = "research_scientists") \%>\%
  dplyr::pull(guid) \%>\%
  get_group_content(client, .)

# Get permissions for all groups by passing in all group guids.
get_group_content(client, groups$guid)
}

}
\seealso{
Other groups functions: 
\code{\link{get_group_members}()},
\code{\link{get_groups}()}
}
\concept{groups functions}
