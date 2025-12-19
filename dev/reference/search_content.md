# Search for content on the Connect server

Search for content on the Connect server

## Usage

``` r
search_content(
  client,
  q = NULL,
  include = "owner,vanity_url",
  page_size = 500,
  limit = Inf,
  ...
)
```

## Arguments

- client:

  A Connect object

- q:

  The search query, using the syntax described in the Connect
  documentation on [content search
  terms](https://docs.posit.co/connect/user/viewing-content/#searching-content)

- include:

  Comma-separated character string of values indicating additional
  details to include in the response. Values can be `owner` and
  `vanity_url`; both are included by default.

- page_size:

  The number of items to fetch per page. Maximum is 500.

- limit:

  Maximum number of items to return overall. Defaults to `Inf` (all
  items).

- ...:

  Additional query parameters passed to the API for future expansion.
  Note: If you pass `page_number` here, it will affect the *starting*
  page for pagination, but all subsequent pages will still be fetched.
  This is usually not what you want.

## Value

A list of
[Content](https://posit-dev.github.io/connectapi/dev/reference/Content.md)
objects, of class "connect_content_list"

## Details

Please see https://docs.posit.co/connect/api/#get-/v1/search/content for
more information.

## See also

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
[`get_job()`](https://posit-dev.github.io/connectapi/dev/reference/get_job.md),
[`get_jobs()`](https://posit-dev.github.io/connectapi/dev/reference/get_jobs.md),
[`get_log()`](https://posit-dev.github.io/connectapi/dev/reference/get_log.md),
[`get_thumbnail()`](https://posit-dev.github.io/connectapi/dev/reference/get_thumbnail.md),
[`get_vanity_url()`](https://posit-dev.github.io/connectapi/dev/reference/get_vanity_url.md),
[`git`](https://posit-dev.github.io/connectapi/dev/reference/git.md),
[`has_thumbnail()`](https://posit-dev.github.io/connectapi/dev/reference/has_thumbnail.md),
[`lock_content()`](https://posit-dev.github.io/connectapi/dev/reference/lock_content.md),
[`permissions`](https://posit-dev.github.io/connectapi/dev/reference/permissions.md),
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
library(connectapi)
client <- connect()

my_content <- search_content(client, q = "owner:@me")

shiny_content <- purrr::keep(my_content, function(x) {
  x$content$app_mode == "rmd-shiny"
})

purrr::map(shiny_content, lock_content)
} # }
```
