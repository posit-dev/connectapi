# Restart a content item.

Submit a request to restart a content item. Once submitted, the server
performs an asynchronous request to kill all processes associated with
the content item, starting new processes as needed. This might be useful
if the application relies on data that is loaded at startup, or if its
memory usage has grown over time.

Note that users interacting with certain types of applications may have
their workflows interrupted.

Only valid for interactive content (e.g., applications, APIs).

## Usage

``` r
content_restart(content)
```

## Arguments

- content:

  The content item you wish to restart.

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()
item <- content_item(client, "8f37d6e0-3395-4a2c-aa6a-d7f2fe1babd0")
content_restart(item)
} # }
```
