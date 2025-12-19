# Download a Bundle from Deployed Connect Content

Downloads a Content item's active bundle, or (optionally) one of its
other bundles.

## Usage

``` r
download_bundle(
  content,
  filename = fs::file_temp(pattern = "bundle", ext = ".tar.gz"),
  bundle_id = NULL,
  overwrite = FALSE
)
```

## Arguments

- content:

  A Content object

- filename:

  Optional. The output bundle path

- bundle_id:

  Optional. A string representing the bundle_id to download. If NULL,
  will use the currently active bundle.

- overwrite:

  Optional. Default FALSE. Whether to overwrite the target location if
  it already exists

## Value

Bundle A bundle object

## See also

Other deployment functions:
[`bundle_dir()`](https://posit-dev.github.io/connectapi/dev/reference/bundle_dir.md),
[`bundle_path()`](https://posit-dev.github.io/connectapi/dev/reference/bundle_path.md),
[`bundle_static()`](https://posit-dev.github.io/connectapi/dev/reference/bundle_static.md),
[`deploy()`](https://posit-dev.github.io/connectapi/dev/reference/deploy.md),
[`poll_task()`](https://posit-dev.github.io/connectapi/dev/reference/poll_task.md)
