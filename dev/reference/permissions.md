# Content permissions

Get or set content permissions for a content item

## Usage

``` r
content_add_user(content, guid, role = c("viewer", "owner"))

content_add_group(content, guid, role = c("viewer", "owner"))

content_delete_user(content, guid)

content_delete_group(content, guid)

get_user_permission(content, guid, add_owner = TRUE)

get_my_permission(content, add_owner = TRUE)

get_group_permission(content, guid)

get_content_permissions(content, add_owner = TRUE)
```

## Arguments

- content:

  An R6 content object

- guid:

  The guid associated with either a user (for `content_add_user`) or
  group (for `content_add_group`)

- role:

  The role to assign to a user. Either "viewer" or "owner." Defaults to
  "viewer"

- add_owner:

  Optional. Whether to include the owner in returned permission sets.
  Default is TRUE. The owner will have an NA_character\_ permission "id"

## Details

Permission modification:

- `content_add_*` adds a permission to the content

- `content_delete_*` removes a permission from the content

Permission retrieval:

- `get_content_permissions()` lists permissions

- `get_my_permission()` gets the permission associated with the caller.

- `get_user_permission()` gets the permissions associated with a given
  user. It does not evaluate group memberships

- `get_group_permission()` gets the permissions associated with a given
  group.

NOTE: by default, the owner is injected with an "NA_character\_"
permission id. This makes it easier to find / isolate this record.

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
