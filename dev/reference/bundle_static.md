# Define a bundle from a static file (or files)

Defines a bundle from static files. It copies all files to a temporary
directory, generates a basic manifest file (using the first file as the
"primary"), and bundles the directory.

## Usage

``` r
bundle_static(
  path,
  filename = fs::file_temp(pattern = "bundle", ext = ".tar.gz")
)
```

## Arguments

- path:

  The path to a file (or files) that will be used for the static bundle

- filename:

  The output bundle path

## Value

Bundle A bundle object

## Details

NOTE: the `rsconnect` package is required for this function to work
properly.

## See also

Other deployment functions:
[`bundle_dir()`](https://posit-dev.github.io/connectapi/dev/reference/bundle_dir.md),
[`bundle_path()`](https://posit-dev.github.io/connectapi/dev/reference/bundle_path.md),
[`deploy()`](https://posit-dev.github.io/connectapi/dev/reference/deploy.md),
[`download_bundle()`](https://posit-dev.github.io/connectapi/dev/reference/download_bundle.md),
[`poll_task()`](https://posit-dev.github.io/connectapi/dev/reference/poll_task.md)

## Examples

``` r
bundle_static(system.file("logo.png", package = "connectapi"))
#> Bundling directory (/tmp/RtmpaLN41H/bundledir238b5aab8668)
#> Posit Connect Bundle: 
#>   Path: /tmp/RtmpaLN41H/bundle238b6e7e4f66.tar.gz
#>   Size: 23.9K
#> 
#> bundle_path("/tmp/RtmpaLN41H/bundle238b6e7e4f66.tar.gz")
#> 
```
