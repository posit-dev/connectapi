# Set a Schedule

**\[experimental\]** Sets the schedule for a given Variant. Requires a
`Schedule` object (as returned by
[`get_variant_schedule()`](https://posit-dev.github.io/connectapi/dev/reference/get_variant_schedule.md))

## Usage

``` r
set_schedule(.schedule, ...)

set_schedule_minute(
  .schedule,
  n = 30,
  start_time = Sys.time(),
  activate = TRUE,
  email = FALSE,
  timezone = Sys.timezone()
)

set_schedule_hour(
  .schedule,
  n = 1,
  start_time = Sys.time(),
  activate = TRUE,
  email = FALSE,
  timezone = Sys.timezone()
)

set_schedule_day(
  .schedule,
  n = 1,
  start_time = Sys.time(),
  activate = TRUE,
  email = FALSE,
  timezone = Sys.timezone()
)

set_schedule_weekday(
  .schedule,
  start_time = Sys.time(),
  activate = TRUE,
  email = FALSE,
  timezone = Sys.timezone()
)

set_schedule_week(
  .schedule,
  n = 1,
  start_time = Sys.time(),
  activate = TRUE,
  email = FALSE,
  timezone = Sys.timezone()
)

set_schedule_dayofweek(
  .schedule,
  days,
  start_time = Sys.time(),
  activate = TRUE,
  email = FALSE,
  timezone = Sys.timezone()
)

set_schedule_semimonth(
  .schedule,
  first = TRUE,
  start_time = Sys.time(),
  activate = TRUE,
  email = FALSE,
  timezone = Sys.timezone()
)

set_schedule_dayofmonth(
  .schedule,
  n = 1,
  day = 1,
  start_time = Sys.time(),
  activate = TRUE,
  email = FALSE,
  timezone = Sys.timezone()
)

set_schedule_dayweekofmonth(
  .schedule,
  n = 1,
  day = 1,
  week = 1,
  start_time = Sys.time(),
  activate = TRUE,
  email = FALSE,
  timezone = Sys.timezone()
)

set_schedule_year(
  .schedule,
  n = 1,
  start_time = Sys.time(),
  activate = TRUE,
  email = FALSE,
  timezone = Sys.timezone()
)

set_schedule_remove(.schedule)

schedule_describe(.schedule)
```

## Arguments

- .schedule:

  A schedule object. As returned by
  [`get_variant_schedule()`](https://posit-dev.github.io/connectapi/dev/reference/get_variant_schedule.md)

- ...:

  Scheduling parameters

- n:

  The "number of" iterations

- start_time:

  The start time of the schedule

- activate:

  Whether to publish the output of this schedule

- email:

  Whether to send emails on this schedule

- timezone:

  The timezone to use for setting the schedule. Defaults to
  [`Sys.timezone()`](https://rdrr.io/r/base/timezones.html)

- days:

  The days of the week (0-6)

- first:

  [logical](https://rdrr.io/r/base/logical.html) Whether to execute on
  the 1st and 15th (TRUE) or 14th and last (FALSE)

- day:

  The day of the week (0-6) or day of the month (0-31)

- week:

  The week of the month (0-5)

- schedule:

  A JSON blob (as a string) describing the schedule. See "More Details"

## Value

An updated Schedule object

## Details

- `set_schedule()` is a raw interface to Posit Connect's `schedule` API

- `set_schedule_*()` functions provide handy wrappers around
  `set_schedule()`

- `set_schedule_remove()` removes a schedule / un-schedules a variant

Beware, using `set_schedule()` currently uses the Posit Connect
`schedule` API directly, and so can be a little clunky. Using the
`set_schedule_*()` is generally recommended.

## See also

Other schedule functions:
[`get_timezones()`](https://posit-dev.github.io/connectapi/dev/reference/get_timezones.md),
[`get_variant_schedule()`](https://posit-dev.github.io/connectapi/dev/reference/get_variant_schedule.md)
