# Get Real-Time Process Data

**\[experimental\]** This returns real-time process data from the Posit
Connect API. It requires administrator privileges to use. NOTE that this
only returns data for the server that responds to the request (i.e. in a
Highly Available cluster)

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
