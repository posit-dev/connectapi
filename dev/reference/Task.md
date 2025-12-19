# Task

Task

Task

## Details

An R6 class that represents a Task

## See also

Other R6 classes:
[`Bundle`](https://posit-dev.github.io/connectapi/dev/reference/Bundle.md),
[`Content`](https://posit-dev.github.io/connectapi/dev/reference/Content.md),
[`ContentTask`](https://posit-dev.github.io/connectapi/dev/reference/ContentTask.md),
[`Environment`](https://posit-dev.github.io/connectapi/dev/reference/EnvironmentR6.md),
[`PositConnect`](https://posit-dev.github.io/connectapi/dev/reference/PositConnect.md),
[`Vanity`](https://posit-dev.github.io/connectapi/dev/reference/Vanity.md),
[`Variant`](https://posit-dev.github.io/connectapi/dev/reference/VariantR6.md),
[`VariantSchedule`](https://posit-dev.github.io/connectapi/dev/reference/VariantSchedule.md),
[`VariantTask`](https://posit-dev.github.io/connectapi/dev/reference/VariantTask.md)

## Public fields

- `connect`:

  The Connect instance.

- `task`:

  The task.

- `data`:

  The task data.

## Methods

### Public methods

- [`Task$new()`](#method-Task-new)

- [`Task$get_task()`](#method-Task-get_task)

- [`Task$add_data()`](#method-Task-add_data)

- [`Task$get_data()`](#method-Task-get_data)

- [`Task$print()`](#method-Task-print)

- [`Task$clone()`](#method-Task-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize this task.

#### Usage

    Task$new(connect, task)

#### Arguments

- `connect`:

  The `Connect` instance.

- `task`:

  The task data.

------------------------------------------------------------------------

### Method `get_task()`

Return the underlying task.

#### Usage

    Task$get_task()

------------------------------------------------------------------------

### Method `add_data()`

Set the data.

#### Usage

    Task$add_data(data)

#### Arguments

- `data`:

  The data.

------------------------------------------------------------------------

### Method `get_data()`

Get the data.

#### Usage

    Task$get_data()

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print this object.

#### Usage

    Task$print(...)

#### Arguments

- `...`:

  Unused.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Task$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
