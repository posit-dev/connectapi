# Get information about content on the Posit Connect server

Get information about content on the Posit Connect server

## Usage

``` r
get_content(src, guid = NULL, owner_guid = NULL, name = NULL, ..., .p = NULL)
```

## Arguments

- src:

  A Connect object

- guid:

  The guid for a particular content item

- owner_guid:

  The unique identifier of the user who owns the content

- name:

  The content name specified when the content was created

- ...:

  Extra arguments. Currently not used.

- .p:

  Optional. A predicate function, passed as-is to
  [`purrr::keep()`](https://purrr.tidyverse.org/reference/keep.html)
  before turning the response into a tibble. Can be useful for
  performance.

## Value

A tibble with the following columns:

- `guid`: The unique identifier of this content item.

- `name`: A simple, URL-friendly identifier. Allows alpha-numeric
  characters, hyphens ("-"), and underscores ("\_").

- `title`: The title of this content.

- `description`: A rich description of this content

- `access_type`: Access type describes how this content manages its
  viewers. It may have a value of `all`, `logged_in` or `acl`. The value
  `all` is the most permissive; any visitor to Posit Connect will be
  able to view this content. The value `logged_in` indicates that all
  Posit Connect accounts may view the content. The `acl` value lets
  specifically enumerated users and groups view the content. Users
  configured as collaborators may always view content.

- `connection_timeout`: Maximum number of seconds allowed without data
  sent or received across a client connection. A value of 0 means
  connections will never time-out (not recommended). When null, the
  default `Scheduler.ConnectionTimeout` is used. Applies only to content
  types that are executed on demand.

- `read_timeout`: Maximum number of seconds allowed without data
  received from a client connection. A value of 0 means a lack of client
  (browser) interaction never causes the connection to close. When null,
  the default `Scheduler.ReadTimeout` is used. Applies only to content
  types that are executed on demand.

- `init_timeout`: The maximum number of seconds allowed for an
  interactive application to start. Posit Connect must be able to
  connect to a newly launched Shiny application, for example, before
  this threshold has elapsed. When null, the default
  `Scheduler.InitTimeout` is used. Applies only to content types that
  are executed on demand.

- `idle_timeout`: The maximum number of seconds a worker process for an
  interactive application to remain alive after it goes idle (no active
  connections). When null, the default `Scheduler.IdleTimeout` is used.
  Applies only to content types that are executed on demand.

- `max_processes`: Specifies the total number of concurrent processes
  allowed for a single interactive application. When null, the default
  `Scheduler.MaxProcesses` setting is used. Applies only to content
  types that are executed on demand.

- `min_processes`: Specifies the minimum number of concurrent processes
  allowed for a single interactive application. When null, the default
  `Scheduler.MinProcesses` is used. Applies only to content types that
  are executed on demand.

- `max_conns_per_process`: Specifies the maximum number of client
  connections allowed to an individual process. Incoming connections
  which will exceed this limit are routed to a new process or rejected.
  When null, the default `Scheduler.MaxConnsPerProcess` is used. Applies
  only to content types that are executed on demand.

- `load_factor`: Controls how aggressively new processes are spawned.
  When null, the default `Scheduler.LoadFactor` is used. Applies only to
  content types that are executed on demand.

- `created_time`: The timestamp (RFC3339) indicating when this content
  was created.

- `last_deployed_time`: The timestamp (RFC3339) indicating when this
  content last had a successful bundle deployment performed.

- `bundle_id`: The identifier for the active deployment bundle.
  Automatically assigned upon the successful deployment of that bundle.

- `app_mode`: The runtime model for this content. Has a value of
  `unknown` before data is deployed to this item. Automatically assigned
  upon the first successful bundle deployment. Allowed: `api`,
  `jupyter-static`, `python-api`, `python-bokeh`, `python-dash`,
  `python-streamlit`, `rmd-shiny`, `rmd-static`, `shiny`, `static`,
  `tensorflow-saved-model`, `unknown`.

- `content_category`: Describes the specialization of the content
  runtime model. Automatically assigned upon the first successful bundle
  deployment.

- `parameterized`: True when R Markdown rendered content allows
  parameter configuration. Automatically assigned upon the first
  successful bundle deployment. Applies only to content with an app_mode
  of rmd-static.

- `r_version`: The version of the R interpreter associated with this
  content. The value null represents that an R interpreter is not used
  by this content or that the R package environment has not been
  successfully restored. Automatically assigned upon the successful
  deployment of a bundle.

- `py_version`: The version of the Python interpreter associated with
  this content. The value null represents that a Python interpreter is
  not used by this content or that the Python package environment has
  not been successfully restored. Automatically assigned upon the
  successful deployment of a bundle.

- `run_as`: The UNIX user that executes this content. When null, the
  default Applications.RunAs is used. Applies only to executable content
  types - not static.

- `run_as_current_user`: Indicates if this content is allowed to execute
  as the logged-in user when using PAM authentication. Applies only to
  executable content types - not static.

- `owner_guid`: The unique identifier for the owner

- `content_url`: The URL associated with this content. Computed from the
  GUID for this content.

- `dashboard_url`: The URL within the Connect dashboard where this
  content can be configured. Computed from the GUID for this content.

- `role`: The relationship of the accessing user to this content. A
  value of owner is returned for the content owner. editor indicates a
  collaborator. The viewer value is given to users who are permitted to
  view the content. A none role is returned for administrators who
  cannot view the content but are permitted to view its configuration.
  Computed at the time of the request.

- `vanity_url`: The vanity URL associated with this content item.

- `id`: The internal numeric identifier of this content item.

- `tags`: Tags associated with this content item. Each entry is a list
  with the following fields:

  - `id`: The identifier for the tag.

  - `name`: The name of the tag.

  - `parent_id`: The identifier for the parent tag. Null if the tag is a
    top-level tag.

  - `created_time`: The timestamp (RFC3339) indicating when the tag was
    created.

  - `updated_time`: The timestamp (RFC3339) indicating when the tag was
    last updated.

- `owner`: Basic details about the owner of this content item. Each
  entry is a list with the following fields:

  - `guid`: The user's GUID, or unique identifier, in UUID RFC4122
    format.

  - `username`: The user's username.

  - `first_name`: The user's first name.

  - `last_name`: The user's last name.

## Details

Please see https://docs.posit.co/connect/api/#get-/v1/content for more
information.

## Examples

``` r
if (FALSE) { # \dontrun{
library(connectapi)
client <- connect()

get_content(client)
} # }
```
