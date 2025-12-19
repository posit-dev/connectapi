# Get runtime caches

View the runtime caches on a Connect server. Requires Administrator
privileges.

## Usage

``` r
get_runtime_caches(client)
```

## Arguments

- client:

  A `Connect` object.

## Value

A tibble of runtime caches on the server, showing `language`, `version`
and `image_name`. For Connect servers not using off-host execution,
`image_name` is `"Local"`.

## See also

[`delete_runtime_cache()`](https://posit-dev.github.io/connectapi/dev/reference/delete_runtime_cache.md)

Other server management functions:
[`delete_runtime_cache()`](https://posit-dev.github.io/connectapi/dev/reference/delete_runtime_cache.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()
get_runtime_caches(client)
} # }
```
