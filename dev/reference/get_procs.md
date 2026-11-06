# Get Real-Time Process Data

**\[experimental\]** This returns real-time process data from the Posit
Connect API. It requires administrator privileges to use. Processes are
returned across all nodes in a Highly Available cluster and across
execution modes (including off-host execution, e.g. Kubernetes).

## Usage

``` r
get_procs(src)
```

## Arguments

- src:

  The source object

## Value

A tibble with the following columns:

- `pid`: The PID of the current process

- `appId`: The application ID

- `appGuid`: The application GUID

- `appName`: The application name

- `appUrl`: The application URL

- `appRunAs`: The application RunAs user

- `type`: The type of process

- `cpuCurrent`: The current CPU usage

- `cpuTotal`: The total CPU usage

- `ram`: The current RAM usage

## Details

Note that:

- Usage metrics (e.g. CPU and RAM) are the values most recently reported
  by each process, so they may be stale, or `NA` if the process has not
  yet reported any metrics.

- Processes that have recently ended but have not yet been finalized may
  still appear in the results.

- This function uses an internal, unversioned API endpoint, so its
  behavior and the returned columns may change in future versions of
  Connect.
