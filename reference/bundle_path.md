# Define a bundle from a path (a path directly to a tar.gz file)

Define a bundle from a path (a path directly to a tar.gz file)

## Usage

``` r
bundle_path(path)
```

## Arguments

- path:

  The path to a .tar.gz file

## Value

Bundle A bundle object

## See also

Other deployment functions:
[`bundle_dir()`](https://posit-dev.github.io/connectapi/reference/bundle_dir.md),
[`bundle_static()`](https://posit-dev.github.io/connectapi/reference/bundle_static.md),
[`deploy()`](https://posit-dev.github.io/connectapi/reference/deploy.md),
[`download_bundle()`](https://posit-dev.github.io/connectapi/reference/download_bundle.md),
[`poll_task()`](https://posit-dev.github.io/connectapi/reference/poll_task.md)

## Examples

``` r
bundle_path(system.file("tests/testthat/examples/static.tar.gz", package = "connectapi"))
#> Bundling path 
#> Posit Connect Bundle: 
#>   Path: /home/runner/work/connectapi/connectapi/docs/reference
#>   Size: 4K
#> 
#> bundle_path("/home/runner/work/connectapi/connectapi/docs/reference")
#> 
```
