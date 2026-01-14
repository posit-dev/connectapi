# Terminate Jobs

Register a job kill order for one or more jobs associated with a content
item. Requires Connect 2022.10.0 or newer.

## Usage

``` r
terminate_jobs(content, keys = NULL)
```

## Arguments

- content:

  A Content object, as returned by
  [`content_item()`](https://posit-dev.github.io/connectapi/reference/content_item.md)

- keys:

  Optional. One or more job keys, which can be obtained using
  `get_jobs(content)`. If no keys are provided, will terminate all
  active jobs for the provided content item.

## Value

A data frame with the status of each termination request.

- `app_id`: The content item's identifier.

- `app_guid`: The content item's GUID.

- `job_key`: The job key.

- `job_id`: The job's identifier.

- `result`: The result string returned by Connect.

- `code`: An error code, `NA` if the request was successful.

- `error`: An error message, `NA` if the result was successful.

Note that `app_id`, `app_guid`, `job_id`, and `result` are `NA` if the
request returns an error.

## See also

Other job functions:
[`get_jobs()`](https://posit-dev.github.io/connectapi/reference/get_jobs.md),
[`get_log()`](https://posit-dev.github.io/connectapi/reference/get_log.md)

Other content functions:
[`content_delete()`](https://posit-dev.github.io/connectapi/reference/content_delete.md),
[`content_item()`](https://posit-dev.github.io/connectapi/reference/content_item.md),
[`content_title()`](https://posit-dev.github.io/connectapi/reference/content_title.md),
[`content_update()`](https://posit-dev.github.io/connectapi/reference/content_update.md),
[`create_random_name()`](https://posit-dev.github.io/connectapi/reference/create_random_name.md),
[`dashboard_url()`](https://posit-dev.github.io/connectapi/reference/dashboard_url.md),
[`delete_thumbnail()`](https://posit-dev.github.io/connectapi/reference/delete_thumbnail.md),
[`delete_vanity_url()`](https://posit-dev.github.io/connectapi/reference/delete_vanity_url.md),
[`deploy_repo()`](https://posit-dev.github.io/connectapi/reference/deploy_repo.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/reference/get_associations.md),
[`get_bundles()`](https://posit-dev.github.io/connectapi/reference/get_bundles.md),
[`get_environment()`](https://posit-dev.github.io/connectapi/reference/environment.md),
[`get_image()`](https://posit-dev.github.io/connectapi/reference/get_image.md),
[`get_jobs()`](https://posit-dev.github.io/connectapi/reference/get_jobs.md),
[`get_log()`](https://posit-dev.github.io/connectapi/reference/get_log.md),
[`get_thumbnail()`](https://posit-dev.github.io/connectapi/reference/get_thumbnail.md),
[`get_vanity_url()`](https://posit-dev.github.io/connectapi/reference/get_vanity_url.md),
[`git`](https://posit-dev.github.io/connectapi/reference/git.md),
[`has_thumbnail()`](https://posit-dev.github.io/connectapi/reference/has_thumbnail.md),
[`lock_content()`](https://posit-dev.github.io/connectapi/reference/lock_content.md),
[`permissions`](https://posit-dev.github.io/connectapi/reference/permissions.md),
[`search_content()`](https://posit-dev.github.io/connectapi/reference/search_content.md),
[`set_image_path()`](https://posit-dev.github.io/connectapi/reference/set_image.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/reference/set_integrations.md),
[`set_run_as()`](https://posit-dev.github.io/connectapi/reference/set_run_as.md),
[`set_thumbnail()`](https://posit-dev.github.io/connectapi/reference/set_thumbnail.md),
[`set_vanity_url()`](https://posit-dev.github.io/connectapi/reference/set_vanity_url.md),
[`swap_vanity_urls()`](https://posit-dev.github.io/connectapi/reference/swap_vanity_urls.md),
[`verify_content_name()`](https://posit-dev.github.io/connectapi/reference/verify_content_name.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()
item <- content_item(client, "951bf3ad-82d0-4bca-bba8-9b27e35c49fa")
result <- terminate_jobs(item)
} # }
```
