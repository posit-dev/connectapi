# Deploy a bundle

Deploys a bundle (tarball) to an Posit Connect server. If not provided,
`name` (a unique identifier) will be an auto-generated alphabetic
string. If deploying to an existing endpoint, you can set `name` or
`guid` to the desired content.

## Usage

``` r
deploy(
  connect,
  bundle,
  name = create_random_name(),
  title = name,
  guid = NULL,
  ...,
  .pre_deploy = {
 }
)

deploy_current(content)
```

## Arguments

- connect:

  A Connect object

- bundle:

  A Bundle object

- name:

  The unique name for the content on the server

- title:

  optional The title to be used for the content on the server

- guid:

  optional The GUID if the content already exists on the server

- ...:

  Additional arguments passed along to the content creation

- .pre_deploy:

  An expression to execute before deploying the new bundle. The
  variables `content` and `bundle_id` are supplied

- content:

  A Content object

## Value

Task A task object

## Details

This function accepts the same arguments as
[`connectapi::content_update()`](https://posit-dev.github.io/connectapi/reference/content_update.md).

`deploy_current()` is a helper to easily redeploy the currently active
bundle for an existing content item.

## See also

connectapi::content_update

Other deployment functions:
[`bundle_dir()`](https://posit-dev.github.io/connectapi/reference/bundle_dir.md),
[`bundle_path()`](https://posit-dev.github.io/connectapi/reference/bundle_path.md),
[`bundle_static()`](https://posit-dev.github.io/connectapi/reference/bundle_static.md),
[`download_bundle()`](https://posit-dev.github.io/connectapi/reference/download_bundle.md),
[`poll_task()`](https://posit-dev.github.io/connectapi/reference/poll_task.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()

# beware bundling big directories, like `renv/`, `data/`, etc.
bnd <- bundle_dir(".")

deploy(client, bnd)
} # }

client <- connect()
#> Defining Connect with server: http://localhost:3939
bnd <- bundle_path(system.file("tests/testthat/examples/static.tar.gz", package = "connectapi"))
#> Bundling path 
deploy(client, bnd)
#> Getting content endpoint
#> 
#> Uploading bundle
#> Warning: 'raw = FALSE' but '/home/runner/work/connectapi/connectapi/docs/reference' is not a regular file
#> Warning: cannot open file '/home/runner/work/connectapi/connectapi/docs/reference': it is a directory
#> Error in file(body$path, "rb"): cannot open the connection
```
