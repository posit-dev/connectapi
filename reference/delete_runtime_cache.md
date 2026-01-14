# Delete a runtime cache

Delete a runtime cache from a Connect server. Requires Administrator
privileges.

## Usage

``` r
delete_runtime_cache(
  client,
  language,
  version,
  image_name = "Local",
  dry_run = FALSE
)
```

## Arguments

- client:

  A `Connect` object.

- language:

  The language of the cache, either "R" or "Python".

- version:

  The version of the cache, e.g. "4.3.3".

- image_name:

  Optional. The name of the off-host execution image for the cache, or
  "Local" (the default) for native execution caches.

- dry_run:

  Optional, default `FALSE`. If true, perform a dry run of the deletion.

## Value

A `Task` object representing the deletion task. If `dry_run` is `TRUE`,
returns `NULL` or throws an error if the deletion would fail.

## See also

[`get_runtime_caches()`](https://posit-dev.github.io/connectapi/reference/get_runtime_caches.md)

Other server management functions:
[`get_runtime_caches()`](https://posit-dev.github.io/connectapi/reference/get_runtime_caches.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()
task <- delete_runtime_cache(client, "R", "4.3.3")
poll_task(task)
} # }
```
