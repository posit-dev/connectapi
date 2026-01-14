# Vanity

Vanity

Vanity

## Details

An R6 class that represents a Vanity URL

## See also

Other R6 classes:
[`Bundle`](https://posit-dev.github.io/connectapi/reference/Bundle.md),
[`Content`](https://posit-dev.github.io/connectapi/reference/Content.md),
[`ContentTask`](https://posit-dev.github.io/connectapi/reference/ContentTask.md),
[`Environment`](https://posit-dev.github.io/connectapi/reference/EnvironmentR6.md),
[`PositConnect`](https://posit-dev.github.io/connectapi/reference/PositConnect.md),
[`Task`](https://posit-dev.github.io/connectapi/reference/Task.md),
[`Variant`](https://posit-dev.github.io/connectapi/reference/VariantR6.md),
[`VariantSchedule`](https://posit-dev.github.io/connectapi/reference/VariantSchedule.md),
[`VariantTask`](https://posit-dev.github.io/connectapi/reference/VariantTask.md)

## Super class

[`connectapi::Content`](https://posit-dev.github.io/connectapi/reference/Content.md)
-\> `Vanity`

## Public fields

- `vanity`:

  The vanity.

## Methods

### Public methods

- [`Vanity$new()`](#method-Vanity-new)

- [`Vanity$get_vanity()`](#method-Vanity-get_vanity)

- [`Vanity$print()`](#method-Vanity-print)

- [`Vanity$clone()`](#method-Vanity-clone)

Inherited methods

- [`connectapi::Content$bundle_delete()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-bundle_delete)
- [`connectapi::Content$bundle_download()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-bundle_download)
- [`connectapi::Content$danger_delete()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-danger_delete)
- [`connectapi::Content$deploy()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-deploy)
- [`connectapi::Content$environment()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-environment)
- [`connectapi::Content$environment_all()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-environment_all)
- [`connectapi::Content$environment_set()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-environment_set)
- [`connectapi::Content$get_bundles()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-get_bundles)
- [`connectapi::Content$get_content_remote()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-get_content_remote)
- [`connectapi::Content$get_dashboard_url()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-get_dashboard_url)
- [`connectapi::Content$get_url()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-get_url)
- [`connectapi::Content$jobs()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-jobs)
- [`connectapi::Content$packages()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-packages)
- [`connectapi::Content$permissions()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-permissions)
- [`connectapi::Content$permissions_add()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-permissions_add)
- [`connectapi::Content$permissions_delete()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-permissions_delete)
- [`connectapi::Content$permissions_update()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-permissions_update)
- [`connectapi::Content$register_job_kill_order()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-register_job_kill_order)
- [`connectapi::Content$repo_enable()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-repo_enable)
- [`connectapi::Content$repo_set()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-repo_set)
- [`connectapi::Content$repository()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-repository)
- [`connectapi::Content$tag_delete()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-tag_delete)
- [`connectapi::Content$tag_set()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-tag_set)
- [`connectapi::Content$tags()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-tags)
- [`connectapi::Content$update()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-update)
- [`connectapi::Content$variants()`](https://posit-dev.github.io/connectapi/reference/Content.html#method-variants)

------------------------------------------------------------------------

### Method `new()`

Initialize this vanity.

#### Usage

    Vanity$new(connect, content, vanity)

#### Arguments

- `connect`:

  The `Connect` instance.

- `content`:

  The `Content` instance.

- `vanity`:

  The vanity data.

------------------------------------------------------------------------

### Method `get_vanity()`

Return the underlying vanity.

#### Usage

    Vanity$get_vanity()

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print this object.

#### Usage

    Vanity$print(...)

#### Arguments

- `...`:

  Unused.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Vanity$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
