# VariantSchedule

VariantSchedule

VariantSchedule

## Details

An R6 class that represents a Schedule

## See also

Other R6 classes:
[`Bundle`](https://posit-dev.github.io/connectapi/dev/reference/Bundle.md),
[`Content`](https://posit-dev.github.io/connectapi/dev/reference/Content.md),
[`ContentTask`](https://posit-dev.github.io/connectapi/dev/reference/ContentTask.md),
[`Environment`](https://posit-dev.github.io/connectapi/dev/reference/EnvironmentR6.md),
[`PositConnect`](https://posit-dev.github.io/connectapi/dev/reference/PositConnect.md),
[`Task`](https://posit-dev.github.io/connectapi/dev/reference/Task.md),
[`Vanity`](https://posit-dev.github.io/connectapi/dev/reference/Vanity.md),
[`Variant`](https://posit-dev.github.io/connectapi/dev/reference/VariantR6.md),
[`VariantTask`](https://posit-dev.github.io/connectapi/dev/reference/VariantTask.md)

## Super classes

[`connectapi::Content`](https://posit-dev.github.io/connectapi/dev/reference/Content.md)
-\>
[`connectapi::Variant`](https://posit-dev.github.io/connectapi/dev/reference/VariantR6.md)
-\> `VariantSchedule`

## Public fields

- `schedule_data`:

  The schedule data.

## Methods

### Public methods

- [`VariantSchedule$new()`](#method-VariantSchedule-new)

- [`VariantSchedule$GET()`](#method-VariantSchedule-GET)

- [`VariantSchedule$POST()`](#method-VariantSchedule-POST)

- [`VariantSchedule$DELETE()`](#method-VariantSchedule-DELETE)

- [`VariantSchedule$set_schedule()`](#method-VariantSchedule-set_schedule)

- [`VariantSchedule$is_empty()`](#method-VariantSchedule-is_empty)

- [`VariantSchedule$print()`](#method-VariantSchedule-print)

- [`VariantSchedule$get_schedule()`](#method-VariantSchedule-get_schedule)

- [`VariantSchedule$get_schedule_remote()`](#method-VariantSchedule-get_schedule_remote)

- [`VariantSchedule$describe_schedule()`](#method-VariantSchedule-describe_schedule)

- [`VariantSchedule$clone()`](#method-VariantSchedule-clone)

Inherited methods

- [`connectapi::Content$bundle_delete()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-bundle_delete)
- [`connectapi::Content$bundle_download()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-bundle_download)
- [`connectapi::Content$danger_delete()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-danger_delete)
- [`connectapi::Content$deploy()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-deploy)
- [`connectapi::Content$environment()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-environment)
- [`connectapi::Content$environment_all()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-environment_all)
- [`connectapi::Content$environment_set()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-environment_set)
- [`connectapi::Content$get_bundles()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-get_bundles)
- [`connectapi::Content$get_content_remote()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-get_content_remote)
- [`connectapi::Content$packages()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-packages)
- [`connectapi::Content$permissions()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-permissions)
- [`connectapi::Content$permissions_add()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-permissions_add)
- [`connectapi::Content$permissions_delete()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-permissions_delete)
- [`connectapi::Content$permissions_update()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-permissions_update)
- [`connectapi::Content$register_job_kill_order()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-register_job_kill_order)
- [`connectapi::Content$repo_enable()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-repo_enable)
- [`connectapi::Content$repo_set()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-repo_set)
- [`connectapi::Content$repository()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-repository)
- [`connectapi::Content$tag_delete()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-tag_delete)
- [`connectapi::Content$tag_set()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-tag_set)
- [`connectapi::Content$tags()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-tags)
- [`connectapi::Content$update()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-update)
- [`connectapi::Content$variants()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-variants)
- [`connectapi::Variant$add_subscribers()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-add_subscribers)
- [`connectapi::Variant$get_dashboard_url()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-get_dashboard_url)
- [`connectapi::Variant$get_subscribers()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-get_subscribers)
- [`connectapi::Variant$get_url()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-get_url)
- [`connectapi::Variant$get_url_rev()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-get_url_rev)
- [`connectapi::Variant$get_variant_remote()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-get_variant_remote)
- [`connectapi::Variant$job()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-job)
- [`connectapi::Variant$jobs()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-jobs)
- [`connectapi::Variant$remove_subscriber()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-remove_subscriber)
- [`connectapi::Variant$render()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-render)
- [`connectapi::Variant$renderings()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-renderings)
- [`connectapi::Variant$send_mail()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-send_mail)
- [`connectapi::Variant$update_variant()`](https://posit-dev.github.io/connectapi/dev/reference/Variant.html#method-update_variant)

------------------------------------------------------------------------

### Method `new()`

Initialize this schedule.

#### Usage

    VariantSchedule$new(connect, content, key, schedule)

#### Arguments

- `connect`:

  The `Connect` instance.

- `content`:

  The `Content` instance.

- `key`:

  The variant key.

- `schedule`:

  The schedule data.

------------------------------------------------------------------------

### Method `GET()`

Perform an HTTP GET request of the named API path. Returns an object
parsed from the HTTP response.

#### Usage

    VariantSchedule$GET(path)

#### Arguments

- `path`:

  API path.

------------------------------------------------------------------------

### Method `POST()`

Perform an HTTP POST request of the named API path. Returns an object
parsed from the HTTP response.

#### Usage

    VariantSchedule$POST(path, body)

#### Arguments

- `path`:

  API path.

- `body`:

  The HTTP payload.

------------------------------------------------------------------------

### Method `DELETE()`

Perform an HTTP DELETE request of the named API path. Returns the HTTP
response object.

#### Usage

    VariantSchedule$DELETE(path)

#### Arguments

- `path`:

  API path.

------------------------------------------------------------------------

### Method [`set_schedule()`](https://posit-dev.github.io/connectapi/dev/reference/set_schedule.md)

Set the schedule for this variant

#### Usage

    VariantSchedule$set_schedule(...)

#### Arguments

- `...`:

  Schedule fields.

------------------------------------------------------------------------

### Method `is_empty()`

Return if this variant has a schedule.

#### Usage

    VariantSchedule$is_empty()

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print this object.

#### Usage

    VariantSchedule$print(...)

#### Arguments

- `...`:

  Unused.

------------------------------------------------------------------------

### Method `get_schedule()`

Get the schedule data.

#### Usage

    VariantSchedule$get_schedule()

------------------------------------------------------------------------

### Method `get_schedule_remote()`

Get and store the (remote) schedule data.

#### Usage

    VariantSchedule$get_schedule_remote()

------------------------------------------------------------------------

### Method `describe_schedule()`

Description of the associated schedule.

#### Usage

    VariantSchedule$describe_schedule()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    VariantSchedule$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
