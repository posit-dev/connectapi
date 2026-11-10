# Get running processes

Returns the processes that Connect has started for content and that have
not yet finished, with their most recent CPU and memory use. This is the
data shown on the **System \> Processes** page of the Connect dashboard.
It requires administrator privileges.

## Usage

``` r
get_processes(src, content_guid = NULL, owner_guid = NULL, hostname = NULL)
```

## Arguments

- src:

  A Connect R6 client object.

- content_guid:

  Optional. Return only processes for the content item with this GUID.
  It is an error if no content item has this GUID.

- owner_guid:

  Optional. Return only processes for content owned by the user with
  this GUID. It is an error if no user has this GUID.

- hostname:

  Optional. Return only processes running on the Connect node with this
  hostname.

## Value

A tibble with one row per process and the following columns:

- `content_guid`: The GUID of the content item the process belongs to.
  `NA` when the content item no longer exists.

- `content_name`: The title of the content item, or its name when it has
  no title.

- `content_url`: The URL of the content item, including its custom URL
  if it has one.

- `run_as`: The Unix user the process runs as.

- `type`: The kind of work the process does, such as `run_app` or
  `build_report`.

- `pid`: The process identifier on the Connect host. `NA` when Connect
  has not recorded one, such as for off-host execution.

- `hostname`: The name of the Connect node that started the process.

- `job_key`: The key of the job for this process.

- `image`: The container image the process runs in, when using off-host
  execution.

- `start_time`: When the process started.

- `heartbeat`: When the last CPU and memory measurement was taken.

- `cpu_current`: The fraction of one CPU the process used over the last
  measurement interval.

- `ram`: The resident memory of the process at the last measurement, as
  [fs::fs_bytes](https://fs.r-lib.org/reference/fs_bytes.html).

## Details

The results cover every node in a Highly Available cluster and include
processes that run with off-host execution (e.g. Kubernetes).

Note that:

- `cpu_current`, `ram`, and `heartbeat` hold the last measurement each
  process reported, so they can be a few seconds old. They are `NA`
  until a process reports its first measurement.

- A process that exited recently can still appear until Connect finishes
  cleaning up after it.

On Connect versions without the `GET /v1/system/processes` endpoint,
this falls back to the older, unversioned `GET /metrics/procs` endpoint.
The results are converted to the same columns, and the filters are
applied client-side.

When more than one filter is given, a process must match all of them.

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()

get_processes(client)

# Only the processes for one content item
get_processes(client, content_guid = "6f300623-1e0c-48e6-a473-ddf630c0c0c3")
} # }
```
