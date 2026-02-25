# Get content item thumbnail

Download the thumbnail for a content item on Connect to a file on your
computer.

## Usage

``` r
get_thumbnail(content, path = NULL)
```

## Arguments

- content:

  A content item.

- path:

  Optional. A path to a file used to write the thumbnail image. If no
  path is provided, a temporary file with the correct file extension is
  created.

## Value

The path to the downloaded image file, if `content` has a thumbnail;
otherwise `NA`.

## See also

Other thumbnail functions:
[`delete_thumbnail()`](https://posit-dev.github.io/connectapi/reference/delete_thumbnail.md),
[`has_thumbnail()`](https://posit-dev.github.io/connectapi/reference/has_thumbnail.md),
[`set_thumbnail()`](https://posit-dev.github.io/connectapi/reference/set_thumbnail.md)

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
[`get_jobs()`](https://posit-dev.github.io/connectapi/reference/get_jobs.md),
[`get_log()`](https://posit-dev.github.io/connectapi/reference/get_log.md),
[`get_vanity_url()`](https://posit-dev.github.io/connectapi/reference/get_vanity_url.md),
[`git`](https://posit-dev.github.io/connectapi/reference/git.md),
[`has_thumbnail()`](https://posit-dev.github.io/connectapi/reference/has_thumbnail.md),
[`lock_content()`](https://posit-dev.github.io/connectapi/reference/lock_content.md),
[`permissions`](https://posit-dev.github.io/connectapi/reference/permissions.md),
[`search_content()`](https://posit-dev.github.io/connectapi/reference/search_content.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/reference/set_integrations.md),
[`set_run_as()`](https://posit-dev.github.io/connectapi/reference/set_run_as.md),
[`set_thumbnail()`](https://posit-dev.github.io/connectapi/reference/set_thumbnail.md),
[`set_vanity_url()`](https://posit-dev.github.io/connectapi/reference/set_vanity_url.md),
[`swap_vanity_urls()`](https://posit-dev.github.io/connectapi/reference/swap_vanity_urls.md),
[`terminate_jobs()`](https://posit-dev.github.io/connectapi/reference/terminate_jobs.md),
[`verify_content_name()`](https://posit-dev.github.io/connectapi/reference/verify_content_name.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()
item <- content_item(client, "8f37d6e0-3395-4a2c-aa6a-d7f2fe1babd0")
thumbnail <- get_thumbnail(item)
} # }
```
