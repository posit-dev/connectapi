# Bundle

Bundle

Bundle

## Details

An R6 class that represents a bundle

## See also

Other R6 classes:
[`Content`](https://posit-dev.github.io/connectapi/reference/Content.md),
[`ContentTask`](https://posit-dev.github.io/connectapi/reference/ContentTask.md),
[`Environment`](https://posit-dev.github.io/connectapi/reference/EnvironmentR6.md),
[`PositConnect`](https://posit-dev.github.io/connectapi/reference/PositConnect.md),
[`Task`](https://posit-dev.github.io/connectapi/reference/Task.md),
[`Vanity`](https://posit-dev.github.io/connectapi/reference/Vanity.md),
[`Variant`](https://posit-dev.github.io/connectapi/reference/VariantR6.md),
[`VariantSchedule`](https://posit-dev.github.io/connectapi/reference/VariantSchedule.md),
[`VariantTask`](https://posit-dev.github.io/connectapi/reference/VariantTask.md)

## Public fields

- `path`:

  The bundle path on disk.

- `size`:

  The size of the bundle.

## Methods

### Public methods

- [`Bundle$new()`](#method-Bundle-new)

- [`Bundle$print()`](#method-Bundle-print)

- [`Bundle$clone()`](#method-Bundle-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize this content bundle.

#### Usage

    Bundle$new(path)

#### Arguments

- `path`:

  The bundle path on disk.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print this object.

#### Usage

    Bundle$print(...)

#### Arguments

- `...`:

  Unused.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Bundle$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
