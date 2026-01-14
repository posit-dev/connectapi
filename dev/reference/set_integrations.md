# Set all OAuth integrations for a content item

Removes all existing OAuth integrations associated with a content item,
and creates associations with the integrations provided. You must have
administrator or publisher privileges to perform this action.

## Usage

``` r
set_integrations(content, integrations)
```

## Arguments

- content:

  A `Content` R6 object representing the content item to modify.

- integrations:

  The complete set of integrations to be associated with the content.
  May be a single `connect_integration` object, a list of
  `connect_integration` objects, or `NULL`. Passing in an empty list or
  explicitly passing `NULL` will remove all associated integrations from
  the content.

## Value

Invisibly returns `NULL`.

## See also

[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/dev/reference/get_associations.md),
[`content_item()`](https://posit-dev.github.io/connectapi/dev/reference/content_item.md)

Other oauth integration functions:
[`create_integration()`](https://posit-dev.github.io/connectapi/dev/reference/create_integration.md),
[`delete_integration()`](https://posit-dev.github.io/connectapi/dev/reference/delete_integration.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/dev/reference/get_associations.md),
[`get_integration()`](https://posit-dev.github.io/connectapi/dev/reference/get_integration.md),
[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md),
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
[`get_associations()`](https://posit-dev.github.io/connectapi/dev/reference/get_associations.md),
[`get_bundles()`](https://posit-dev.github.io/connectapi/dev/reference/get_bundles.md),
[`get_environment()`](https://posit-dev.github.io/connectapi/dev/reference/environment.md),
[`get_image()`](https://posit-dev.github.io/connectapi/dev/reference/get_image.md),
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
[`set_run_as()`](https://posit-dev.github.io/connectapi/dev/reference/set_run_as.md),
[`set_thumbnail()`](https://posit-dev.github.io/connectapi/dev/reference/set_thumbnail.md),
[`set_vanity_url()`](https://posit-dev.github.io/connectapi/dev/reference/set_vanity_url.md),
[`swap_vanity_urls()`](https://posit-dev.github.io/connectapi/dev/reference/swap_vanity_urls.md),
[`terminate_jobs()`](https://posit-dev.github.io/connectapi/dev/reference/terminate_jobs.md),
[`verify_content_name()`](https://posit-dev.github.io/connectapi/dev/reference/verify_content_name.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()

content <- content_item(client, "12345678-90ab-cdef-1234-567890abcdef")

integrations <- get_integrations(client)

# Associate a single integration
github_integration <- purrr::keep(integrations, \(x) x$template == "github")[[1]]
set_integrations(content, github_integration)

# Associate multiple integrations at once
selected_integrations <- integrations[1:2]
set_integrations(content, selected_integrations)

# Unset integrations
set_integrations(content, NULL)
} # }
```
