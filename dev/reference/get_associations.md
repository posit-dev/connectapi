# Get OAuth associations for a piece of content

Given a `Content` object, retrieves a list of its OAuth associations. An
association contains a content GUID and an association GUID, and
indicates that the integration can be used by the content when it runs.

## Usage

``` r
get_associations(x)
```

## Arguments

- x:

  A `Content` object

## Value

A list of OAuth integration associations. Each association includes
details such as:

- `app_guid`: The content item's GUID (deprecated, use `content_guid`
  instead).

- `content_guid`: The content item's GUID.

- `oauth_integration_guid`: The GUID of the OAuth integration.

- `oauth_integration_name`: The name of the OAuth integration.

- `oauth_integration_description`: A description of the OAuth
  integration.

- `oauth_integration_template`: The template used for this OAuth
  integration.

- `oauth_integration_auth_type`: The authentication type (e.g., "Viewer"
  or "Service Account").

- `created_time`: The timestamp when the association was created.

## See also

[`set_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/set_integrations.md),
[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md)

Other oauth integration functions:
[`create_integration()`](https://posit-dev.github.io/connectapi/dev/reference/create_integration.md),
[`delete_integration()`](https://posit-dev.github.io/connectapi/dev/reference/delete_integration.md),
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md),
[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/set_integrations.md),
[`update_integration()`](https://posit-dev.github.io/connectapi/dev/reference/update_integration.md)

Other content functions:
[`content_delete()`](https://posit-dev.github.io/connectapi/dev/reference/content_delete.md),
[`content_item()`](https://posit-dev.github.io/connectapi/dev/reference/content_item.md),
[`content_title()`](https://posit-dev.github.io/connectapi/dev/reference/content_title.md),
[`content_update()`](https://posit-dev.github.io/connectapi/dev/reference/content_update.md),
[`create_random_name()`](https://posit-dev.github.io/connectapi/dev/reference/create_random_name.md),
[`dashboard_url()`](https://posit-dev.github.io/connectapi/dev/reference/dashboard_url.md),
[`delete_thumbnail()`](https://posit-dev.github.io/connectapi/dev/reference/delete_thumbnail.md),
[`delete_vanity_url()`](https://posit-dev.github.io/connectapi/dev/reference/delete_vanity_url.md),
[`deploy_repo()`](https://posit-dev.github.io/connectapi/dev/reference/deploy_repo.md),
[`get_bundles()`](https://posit-dev.github.io/connectapi/dev/reference/get_bundles.md),
[`get_environment()`](https://posit-dev.github.io/connectapi/dev/reference/environment.md),
[`get_image()`](https://posit-dev.github.io/connectapi/dev/reference/get_image.md),
[`get_job()`](https://posit-dev.github.io/connectapi/dev/reference/get_job.md),
[`get_jobs()`](https://posit-dev.github.io/connectapi/dev/reference/get_jobs.md),
[`get_log()`](https://posit-dev.github.io/connectapi/dev/reference/get_log.md),
[`get_thumbnail()`](https://posit-dev.github.io/connectapi/dev/reference/get_thumbnail.md),
[`get_vanity_url()`](https://posit-dev.github.io/connectapi/dev/reference/get_vanity_url.md),
[`git`](https://posit-dev.github.io/connectapi/dev/reference/git.md),
[`has_thumbnail()`](https://posit-dev.github.io/connectapi/dev/reference/has_thumbnail.md),
[`lock_content()`](https://posit-dev.github.io/connectapi/dev/reference/lock_content.md),
[`permissions`](https://posit-dev.github.io/connectapi/dev/reference/permissions.md),
[`search_content()`](https://posit-dev.github.io/connectapi/dev/reference/search_content.md),
[`set_image_path()`](https://posit-dev.github.io/connectapi/dev/reference/set_image.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/set_integrations.md),
[`set_run_as()`](https://posit-dev.github.io/connectapi/dev/reference/set_run_as.md),
[`set_thumbnail()`](https://posit-dev.github.io/connectapi/dev/reference/set_thumbnail.md),
[`set_vanity_url()`](https://posit-dev.github.io/connectapi/dev/reference/set_vanity_url.md),
[`swap_vanity_url()`](https://posit-dev.github.io/connectapi/dev/reference/swap_vanity_url.md),
[`swap_vanity_urls()`](https://posit-dev.github.io/connectapi/dev/reference/swap_vanity_urls.md),
[`terminate_jobs()`](https://posit-dev.github.io/connectapi/dev/reference/terminate_jobs.md),
[`verify_content_name()`](https://posit-dev.github.io/connectapi/dev/reference/verify_content_name.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()

# Get OAuth associations for an app.
my_app <- content_item(client, "12345678-90ab-cdef-1234-567890abcdef")
my_app_associations <- get_associations(my_app)

# Given those associations, retrieve the integrations themselves.
my_app_integrations <- purrr::map(
  my_app_associations,
  ~ get_integration(client, .x$oauth_integration_guid)
)
} # }
```
