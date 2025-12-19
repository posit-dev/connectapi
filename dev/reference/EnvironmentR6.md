# Environment

Environment

Environment

## Details

An R6 class that represents a Content's Environment Variables

## See also

Other R6 classes:
[`Bundle`](https://posit-dev.github.io/connectapi/dev/reference/Bundle.md),
[`Content`](https://posit-dev.github.io/connectapi/dev/reference/Content.md),
[`ContentTask`](https://posit-dev.github.io/connectapi/dev/reference/ContentTask.md),
[`PositConnect`](https://posit-dev.github.io/connectapi/dev/reference/PositConnect.md),
[`Task`](https://posit-dev.github.io/connectapi/dev/reference/Task.md),
[`Vanity`](https://posit-dev.github.io/connectapi/dev/reference/Vanity.md),
[`Variant`](https://posit-dev.github.io/connectapi/dev/reference/VariantR6.md),
[`VariantSchedule`](https://posit-dev.github.io/connectapi/dev/reference/VariantSchedule.md),
[`VariantTask`](https://posit-dev.github.io/connectapi/dev/reference/VariantTask.md)

## Super class

[`connectapi::Content`](https://posit-dev.github.io/connectapi/dev/reference/Content.md)
-\> `Environment`

## Public fields

- `env_raw`:

  The (raw) set of environment variables.

- `env_vars`:

  The set of environment variables.

## Methods

### Public methods

- [`Environment$new()`](#method-Environment-new)

- [`Environment$environment()`](#method-Environment-environment)

- [`Environment$environment_set()`](#method-Environment-environment_set)

- [`Environment$environment_all()`](#method-Environment-environment_all)

- [`Environment$env_refresh()`](#method-Environment-env_refresh)

- [`Environment$print()`](#method-Environment-print)

- [`Environment$clone()`](#method-Environment-clone)

Inherited methods

- [`connectapi::Content$bundle_delete()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-bundle_delete)
- [`connectapi::Content$bundle_download()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-bundle_download)
- [`connectapi::Content$danger_delete()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-danger_delete)
- [`connectapi::Content$deploy()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-deploy)
- [`connectapi::Content$get_bundles()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-get_bundles)
- [`connectapi::Content$get_content_remote()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-get_content_remote)
- [`connectapi::Content$get_dashboard_url()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-get_dashboard_url)
- [`connectapi::Content$get_url()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-get_url)
- [`connectapi::Content$job()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-job)
- [`connectapi::Content$jobs()`](https://posit-dev.github.io/connectapi/dev/reference/Content.html#method-jobs)
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

------------------------------------------------------------------------

### Method `new()`

Initialize this set of environment variables.

#### Usage

    Environment$new(connect, content)

#### Arguments

- `connect`:

  The `Connect` instance.

- `content`:

  The `Content` instance.

------------------------------------------------------------------------

### Method [`environment()`](https://rdrr.io/r/base/environment.html)

Fetch the set of environment variables.

#### Usage

    Environment$environment()

------------------------------------------------------------------------

### Method `environment_set()`

Update the set of environment variables.

#### Usage

    Environment$environment_set(...)

#### Arguments

- `...`:

  Environment variable names and values.

------------------------------------------------------------------------

### Method `environment_all()`

Overwrite the set of environment variables.

#### Usage

    Environment$environment_all(...)

#### Arguments

- `...`:

  Environment variable names and values.

------------------------------------------------------------------------

### Method `env_refresh()`

Fetch the set o environment variables.

#### Usage

    Environment$env_refresh()

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print this object.

#### Usage

    Environment$print(...)

#### Arguments

- `...`:

  Unused.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Environment$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
