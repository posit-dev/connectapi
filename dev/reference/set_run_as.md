# Set RunAs User

Set the `RunAs` user for a piece of content. The `run_as_current_user`
flag only does anything if:

## Usage

``` r
set_run_as(content, run_as, run_as_current_user = FALSE)
```

## Arguments

- content:

  an R6 Content item

- run_as:

  The RunAs user to use for this content

- run_as_current_user:

  Whether to run this content as the viewer of the application

## Value

a Content object, updated with new details

## Details

- PAM is the authentication method

- `Applications.RunAsCurrentUser` is enabled on the server

Also worth noting that the `run_as` user must exist on the Posit Connect
server (as a linux user) and have appropriate group memberships, or you
will get a `400: Bad Request`. Set to `NULL` to use the default RunAs
user / unset any current configuration.

To "read" the current RunAs user, use the `Content` object or
[`get_content()`](https://posit-dev.github.io/connectapi/dev/reference/get_content.md)
function.

## See also

connectapi::content_update

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
[`get_jobs()`](https://posit-dev.github.io/connectapi/dev/reference/get_jobs.md),
[`get_log()`](https://posit-dev.github.io/connectapi/dev/reference/get_log.md),
[`get_thumbnail()`](https://posit-dev.github.io/connectapi/dev/reference/get_thumbnail.md),
[`get_vanity_url()`](https://posit-dev.github.io/connectapi/dev/reference/get_vanity_url.md),
[`git`](https://posit-dev.github.io/connectapi/dev/reference/git.md),
[`has_thumbnail()`](https://posit-dev.github.io/connectapi/dev/reference/has_thumbnail.md),
[`lock_content()`](https://posit-dev.github.io/connectapi/dev/reference/lock_content.md),
[`permissions`](https://posit-dev.github.io/connectapi/dev/reference/permissions.md),
[`search_content()`](https://posit-dev.github.io/connectapi/dev/reference/search_content.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/set_integrations.md),
[`set_thumbnail()`](https://posit-dev.github.io/connectapi/dev/reference/set_thumbnail.md),
[`set_vanity_url()`](https://posit-dev.github.io/connectapi/dev/reference/set_vanity_url.md),
[`swap_vanity_urls()`](https://posit-dev.github.io/connectapi/dev/reference/swap_vanity_urls.md),
[`terminate_jobs()`](https://posit-dev.github.io/connectapi/dev/reference/terminate_jobs.md),
[`verify_content_name()`](https://posit-dev.github.io/connectapi/dev/reference/verify_content_name.md)
