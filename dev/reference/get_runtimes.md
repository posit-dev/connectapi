# Get available runtimes on server

Get a table showing available versions of R, Python, Quarto, and
Tensorflow on the Connect server.

## Usage

``` r
get_runtimes(client, runtimes = NULL)
```

## Arguments

- client:

  A `Connect` object.

- runtimes:

  Optional. A character vector of runtimes to include. Must be some
  combination of `"r"`, `"python"`, `"quarto"`, and `"tensorflow"`.
  Quarto is only supported on Connect \>= 2021.08.0, and Tensorflow is
  only supported on Connect \>= 2024.03.0.

## Value

A tibble with columns for `runtime`, `version`, and `cluster_name` and
`image_name`. Cluster name and image name are only meaningful on Connect
instances running off-host execution.

## Examples

``` r
if (FALSE) { # \dontrun{
library(connectapi)
client <- connect()
get_runtimes(client, runtimes = c("r", "python", "tensorflow"))
} # }
```
