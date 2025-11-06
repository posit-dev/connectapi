# Temporarily skip these on newer Connect versions because the manifest for this
# content specifies an old version of R not found in newer images.
skip_if(safe_server_version(client) > "2024.03.0")

rmd_content <- deploy_example(client, "rmarkdown")

## Test Schedule -------------------------------------------------------

d_var <- (function(rmd_content) {
  scoped_experimental_silence()
  get_variant_default(rmd_content)
})(rmd_content)
d_var_sch <- (function(d_var) {
  scoped_experimental_silence()
  get_variant_schedule(d_var)
})(d_var)

invisible(purrr::map(
  example_schedules,
  function(.x, sch) {
    test_that(
      glue::glue("example schedule {.x$type} works"),
      {
        scoped_experimental_silence()
        sch <- get_variant_schedule(sch)
        sch <- set_schedule(sch, !!!.x, start_time = Sys.time())
        expect_true(validate_R6_class(sch, "VariantSchedule"))
        set_schedule_remove(sch)
      }
    )
  },
  sch = d_var_sch
))

test_that("set_schedule_remove is idempotent", {
  scoped_experimental_silence()
  expect_true(validate_R6_class(set_schedule_remove(d_var_sch), "Variant"))
  expect_true(validate_R6_class(set_schedule_remove(d_var_sch), "Variant"))
  expect_true(validate_R6_class(set_schedule_remove(d_var_sch), "Variant"))
})

test_that("schedule helpers work", {
  scoped_experimental_silence()
  expect_true(
    validate_R6_class(
      set_schedule_remove(set_schedule_minute(get_variant_schedule(d_var_sch))),
      "Variant"
    )
  )
  expect_true(
    validate_R6_class(
      set_schedule_remove(set_schedule_hour(get_variant_schedule(d_var_sch))),
      "Variant"
    )
  )
  expect_true(
    validate_R6_class(
      set_schedule_remove(set_schedule_day(get_variant_schedule(d_var_sch))),
      "Variant"
    )
  )
  expect_true(
    validate_R6_class(
      set_schedule_remove(set_schedule_weekday(get_variant_schedule(
        d_var_sch
      ))),
      "Variant"
    )
  )
  expect_true(
    validate_R6_class(
      set_schedule_remove(set_schedule_week(get_variant_schedule(d_var_sch))),
      "Variant"
    )
  )
  expect_true(
    validate_R6_class(
      set_schedule_remove(set_schedule_dayofweek(
        get_variant_schedule(d_var_sch),
        c(0, 1, 6)
      )),
      "Variant"
    )
  )
  expect_true(
    validate_R6_class(
      set_schedule_remove(set_schedule_semimonth(get_variant_schedule(
        d_var_sch
      ))),
      "Variant"
    )
  )
  expect_true(
    validate_R6_class(
      set_schedule_remove(set_schedule_semimonth(
        get_variant_schedule(d_var_sch),
        FALSE
      )),
      "Variant"
    )
  )
  expect_true(
    validate_R6_class(
      set_schedule_remove(set_schedule_dayofmonth(get_variant_schedule(
        d_var_sch
      ))),
      "Variant"
    )
  )
  expect_true(
    validate_R6_class(
      set_schedule_remove(set_schedule_dayweekofmonth(get_variant_schedule(
        d_var_sch
      ))),
      "Variant"
    )
  )
  expect_true(
    validate_R6_class(
      set_schedule_remove(set_schedule_year(get_variant_schedule(d_var_sch))),
      "Variant"
    )
  )
})

test_that("schedule display works", {
  skip("need a way to make this less time sensitive (with next run)")
  scoped_experimental_silence()

  tzs <- get_timezones(client)

  set_schedule_remove(d_var_sch)
  tmp <- set_schedule_day(
    get_variant_schedule(d_var_sch),
    start_time = as.POSIXct("2022-01-01 00:00:00"),
    n = 2,
    timezone = tzs$`Universal (+00:00)`
  )
  expect_snapshot_output(schedule_describe(tmp))
})

test_that("get_schedules works", {
  scoped_experimental_silence()
  # TODO: add a helper that makes this prettier

  tmp <- set_schedule_day(d_var_sch, n = 5)
  expect_true(validate_R6_class(tmp, "Variant"))

  res <- client$schedules()
  expect_gte(length(res), 1)

  set_schedule_remove(d_var_sch)
})
