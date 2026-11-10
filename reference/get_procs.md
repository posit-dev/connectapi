# Get Real-Time Process Data

**\[deprecated\]**

## Usage

``` r
get_procs(src)
```

## Arguments

- src:

  The source object

## Value

A tibble with one row per process. The columns are those sent by the
server, which in recent versions of Connect are `pid`, `app_id`,
`app_guid`, `app_name`, `app_url`, `app_run_as`, `type`, `cpu_current`,
`ram`, `hostname`, `job_key`, `image`, `start_time`, and `heartbeat`.

## Details

This function is deprecated; please use
[`get_processes()`](https://posit-dev.github.io/connectapi/reference/get_processes.md),
which uses the supported `GET /v1/system/processes` endpoint, can filter
its results, and returns the same columns across Connect versions.

`get_procs()` uses the internal, unversioned `GET /metrics/procs`
endpoint, so its behavior and the returned columns may change in future
versions of Connect. It requires administrator privileges, and returns
processes across all nodes in a Highly Available cluster.
