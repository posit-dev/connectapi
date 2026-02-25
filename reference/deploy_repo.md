# Deploy a Git Repository

**\[experimental\]** Deploy a git repository directly to Posit Connect,
using Posit Connect's "pull-based" "git-polling" method of deployment.

## Usage

``` r
deploy_repo(
  client,
  repository,
  branch,
  subdirectory,
  name = create_random_name(),
  title = name,
  ...
)

deploy_repo_enable(content, enabled = TRUE)

deploy_repo_update(content)
```

## Arguments

- client:

  A Connect R6 object

- repository:

  The git repository to deploy

- branch:

  The git branch to deploy

- subdirectory:

  The subdirectory to deploy (must contain a `manifest.json`)

- name:

  The "name" / unique identifier for the content. Defaults to a random
  character string

- title:

  The "title" of the content

- ...:

  Additional options for defining / specifying content attributes

- content:

  An R6 Content object (i.e. the result of
  [`content_item()`](https://posit-dev.github.io/connectapi/reference/content_item.md))

- enabled:

  Whether Connect will enable automatic polling for repository updates

## Value

A ContentTask object, for use with
[`poll_task()`](https://posit-dev.github.io/connectapi/reference/poll_task.md)
(if you want to follow the logs)

## Details

- `deploy_repo_enable()` enables (or disables) Posit Connect's git
  polling for a piece of content

- `deploy_repo_update()` triggers an update of the content from its git
  repository, if any are present

## See also

connectapi::poll_task, connectapi::repo_check_branches,
connectapi::repo_check_manifest_dirs

Other content functions:
[`content_delete()`](https://posit-dev.github.io/connectapi/reference/content_delete.md),
[`content_item()`](https://posit-dev.github.io/connectapi/reference/content_item.md),
[`content_title()`](https://posit-dev.github.io/connectapi/reference/content_title.md),
[`content_update()`](https://posit-dev.github.io/connectapi/reference/content_update.md),
[`create_random_name()`](https://posit-dev.github.io/connectapi/reference/create_random_name.md),
[`dashboard_url()`](https://posit-dev.github.io/connectapi/reference/dashboard_url.md),
[`delete_thumbnail()`](https://posit-dev.github.io/connectapi/reference/delete_thumbnail.md),
[`delete_vanity_url()`](https://posit-dev.github.io/connectapi/reference/delete_vanity_url.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/reference/get_associations.md),
[`get_bundles()`](https://posit-dev.github.io/connectapi/reference/get_bundles.md),
[`get_environment()`](https://posit-dev.github.io/connectapi/reference/environment.md),
[`get_jobs()`](https://posit-dev.github.io/connectapi/reference/get_jobs.md),
[`get_log()`](https://posit-dev.github.io/connectapi/reference/get_log.md),
[`get_thumbnail()`](https://posit-dev.github.io/connectapi/reference/get_thumbnail.md),
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
