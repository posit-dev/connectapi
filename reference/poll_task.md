# Poll Task

Polls a task, waiting for information about a deployment. If the task
has results, the output will be a modified "Task" object with
`task$get_data()` available to retrieve the results.

## Usage

``` r
poll_task(task, wait = 1, callback = message)
```

## Arguments

- task:

  A Task object

- wait:

  The interval to wait between polling

- callback:

  A function to be called for each message received. Set to NULL for no
  callback

## Value

Task The Task object that was input

## Details

For a simple way to silence messages, set `callback = NULL`

## See also

Other deployment functions:
[`bundle_dir()`](https://posit-dev.github.io/connectapi/reference/bundle_dir.md),
[`bundle_path()`](https://posit-dev.github.io/connectapi/reference/bundle_path.md),
[`bundle_static()`](https://posit-dev.github.io/connectapi/reference/bundle_static.md),
[`deploy()`](https://posit-dev.github.io/connectapi/reference/deploy.md),
[`download_bundle()`](https://posit-dev.github.io/connectapi/reference/download_bundle.md)
