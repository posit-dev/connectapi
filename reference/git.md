# Git Repository Helpers

**\[experimental\]** These functions help use Posit Connect's configured
authorization to query available branches and subdirectories for
deployment using
[`deploy_repo()`](https://posit-dev.github.io/connectapi/reference/deploy_repo.md)

## Usage

``` r
repo_check_account(client, host)

repo_check_branches(client, repository)

repo_check_branches_ref(client, repository)

repo_check_manifest_dirs(client, repository, branch)
```

## Arguments

- client:

  A Connect R6 object

- host:

  The git repository host (with schema). For example,
  "https://github.com"

- repository:

  The git repository to explore or consider deploying

- branch:

  The git branch to explore for subdirectories

## Details

- `repo_check_account()` messages whether an account is in use, and then
  returns that account

- `repo_check_branches()` retrieves which branches are available,
  returning in a named list

- `repo_check_manifest_dirs()` retrieves which directories contain a
  `manifest.json`, returning in a named list

## See also

connectapi::deploy_repo

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
[`get_thumbnail()`](https://posit-dev.github.io/connectapi/reference/get_thumbnail.md),
[`get_vanity_url()`](https://posit-dev.github.io/connectapi/reference/get_vanity_url.md),
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
