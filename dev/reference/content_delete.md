# Delete Content

Delete a content item. WARNING: This action deletes all history,
configuration, logs, and resources about a content item. It *cannot* be
undone.

## Usage

``` r
content_delete(content, force = FALSE)
```

## Arguments

- content:

  an R6 content item

- force:

  Optional. A boolean that determines whether we should prompt in
  interactive sessions

## Value

The R6 Content item. The item is deleted, but information about it is
cached locally

## See also

Other content functions:
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
