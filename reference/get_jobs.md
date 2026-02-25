# Get Jobs

Retrieve details about server processes associated with a
`content_item`, such as a FastAPI app or a Quarto render.

## Usage

``` r
get_jobs(content)

get_job_list(content)
```

## Arguments

- content:

  A Content object, as returned by
  [`content_item()`](https://posit-dev.github.io/connectapi/reference/content_item.md)

## Value

- `get_jobs()`: A data frame with a row representing each job.

- `get_job_list()`: A list with each element representing a job.

Jobs contain the following fields:

- `id`: The job identifier.

- `ppid`: The job's parent process identifier (see Note 1).

- `pid`: The job's process identifier.

- `key`: The job's unique key identifier.

- `remote_id`: The job's identifier for off-host execution
  configurations (see Note 1).

- `app_id`: The job's parent content identifier; deprecated in favor of
  `content_id`.

- `app_guid`: The job's parent content GUID; deprecated in favor of
  `content_guid`.

- `content_id`: The job's parent content identifier.

- `content_guid`: The job's parent content GUID.

- `variant_id`: The identifier of the variant owning this job.

- `bundle_id`: The identifier of a content bundle linked to this job.

- `start_time`: The timestamp (RFC3339) indicating when this job
  started.

- `end_time`: The timestamp (RFC3339) indicating when this job finished.

- `last_heartbeat_time`: The timestamp (RFC3339) indicating the last
  time this job was observed to be running (see Note 1).

- `queued_time`: The timestamp (RFC3339) indicating when this job was
  added to the queue to be processed. Only scheduled reports will
  present a value for this field (see Note 1).

- `queue_name`: The name of the queue which processes the job. Only
  scheduled reports will present a value for this field (see Note 1).

- `tag`: A tag to identify the nature of the job.

- `exit_code`: The job's exit code. Present only when job is finished.

- `status`: The current status of the job. On Connect 2022.10.0 and
  newer, one of Active: 0, Finished: 1, Finalized: 2; on earlier
  versions, Active: 0, otherwise `NA`.

- `hostname`: The name of the node which processes the job.

- `cluster`: The location where this content runs. Content running on
  the same server as Connect will have either a null value or the string
  Local. Gives the name of the cluster when run external to the Connect
  host (see Note 1).

- `image`: The location where this content runs. Content running on the
  same server as Connect will have either a null value or the string
  Local. References the name of the target image when content runs in a
  clustered environment such as Kubernetes (see Note 1).

- `run_as`: The UNIX user that executed this job.

## Details

Note that Connect versions below 2022.10.0 use a legacy endpoint, and
will not return the complete set of information provided by newer
versions.

`get_jobs()` returns job data as a data frame, whereas `get_jobs_list()`
returns job data in a list.

You might get job data as a data frame if you want to perform some
calculations about job data (e.g. counting server processes over time),
or if you want to filter jobs to find a specific key.

The objects in list returned by `get_jobs_list()` are useful if you want
to take an action on a job, such as getting its process log with
[`get_log()`](https://posit-dev.github.io/connectapi/reference/get_log.md).

## Note

1.  On Connect instances earlier than 2022.10.0, these fields will
    contain `NA` values.

## See also

Other job functions:
[`get_log()`](https://posit-dev.github.io/connectapi/reference/get_log.md),
[`terminate_jobs()`](https://posit-dev.github.io/connectapi/reference/terminate_jobs.md)

Other content functions:
[`content_delete()`](https://posit-dev.github.io/connectapi/reference/content_delete.md),
[`content_item()`](https://posit-dev.github.io/connectapi/reference/content_item.md),
[`content_title()`](https://posit-dev.github.io/connectapi/reference/content_title.md),
[`content_update()`](https://posit-dev.github.io/connectapi/reference/content_update.md),
[`create_random_name()`](https://posit-dev.github.io/connectapi/reference/create_random_name.md),
[`dashboard_url()`](https://posit-dev.github.io/connectapi/reference/dashboard_url.md),
[`delete_thumbnail()`](https://posit-dev.github.io/connectapi/reference/delete_thumbnail.md),
[`delete_vanity_url()`](https://posit-dev.github.io/connectapi/reference/delete_vanity_url.md),
[`deploy_repo()`](https://posit-dev.github.io/connectapi/reference/deploy_repo.md),
[`get_associations()`](https://posit-dev.github.io/connectapi/reference/get_associations.md),
[`get_bundles()`](https://posit-dev.github.io/connectapi/reference/get_bundles.md),
[`get_environment()`](https://posit-dev.github.io/connectapi/reference/environment.md),
[`get_log()`](https://posit-dev.github.io/connectapi/reference/get_log.md),
[`get_thumbnail()`](https://posit-dev.github.io/connectapi/reference/get_thumbnail.md),
[`get_vanity_url()`](https://posit-dev.github.io/connectapi/reference/get_vanity_url.md),
[`git`](https://posit-dev.github.io/connectapi/reference/git.md),
[`has_thumbnail()`](https://posit-dev.github.io/connectapi/reference/has_thumbnail.md),
[`lock_content()`](https://posit-dev.github.io/connectapi/reference/lock_content.md),
[`permissions`](https://posit-dev.github.io/connectapi/reference/permissions.md),
[`search_content()`](https://posit-dev.github.io/connectapi/reference/search_content.md),
[`set_integrations()`](https://posit-dev.github.io/connectapi/reference/set_integrations.md),
[`set_run_as()`](https://posit-dev.github.io/connectapi/reference/set_run_as.md),
[`set_thumbnail()`](https://posit-dev.github.io/connectapi/reference/set_thumbnail.md),
[`set_vanity_url()`](https://posit-dev.github.io/connectapi/reference/set_vanity_url.md),
[`swap_vanity_urls()`](https://posit-dev.github.io/connectapi/reference/swap_vanity_urls.md),
[`terminate_jobs()`](https://posit-dev.github.io/connectapi/reference/terminate_jobs.md),
[`verify_content_name()`](https://posit-dev.github.io/connectapi/reference/verify_content_name.md)

## Examples

``` r
if (FALSE) { # \dontrun{
client <- connect()
item <- content_item(client, "951bf3ad-82d0-4bca-bba8-9b27e35c49fa")
jobs <- get_jobs(item)
job_list <- get_job_list(item)
} # }
```
