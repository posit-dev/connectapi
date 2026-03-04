test_that("coerce_datetime fills the void", {
  chardate <- "2023-10-25T17:04:08Z"
  numdate <- as.double(Sys.time())
  na_posixct <- as.POSIXct(NA, tz = Sys.timezone())

  expect_s3_class(coerce_datetime(chardate), "POSIXct")
  expect_s3_class(coerce_datetime(c(chardate, chardate)), "POSIXct")
  expect_s3_class(coerce_datetime(numdate), "POSIXct")
  expect_s3_class(coerce_datetime(c(numdate, numdate)), "POSIXct")
  expect_s3_class(coerce_datetime(na_posixct), "POSIXct")
  expect_s3_class(coerce_datetime(c(na_posixct, na_posixct)), "POSIXct")
  expect_s3_class(coerce_datetime(NA_integer_), "POSIXct")
  expect_s3_class(coerce_datetime(c(NA_integer_, NA_integer_)), "POSIXct")
  expect_s3_class(coerce_datetime(NA), "POSIXct")
  expect_s3_class(coerce_datetime(c(NA, NA)), "POSIXct")
  expect_s3_class(coerce_datetime(NULL), "POSIXct")

  expect_error(coerce_datetime(data.frame()), "Cannot coerce")
  expect_error(coerce_datetime(NA_complex_), "Cannot coerce")
})

test_that("parse_connect_rfc3339() parses timestamps with offsets as expected", {
  x_mixed <- c(
    "2023-08-22T14:13:14Z",
    "2020-01-01T01:02:03Z",
    "2023-08-22T15:13:14+01:00",
    "2020-01-01T00:02:03-01:00"
  )

  x_zero_offset <- c(
    "2023-08-22T14:13:14Z",
    "2020-01-01T01:02:03Z"
  )

  x_plus_one <- c(
    "2023-08-22T15:13:14+01:00",
    "2020-01-01T02:02:03+01:00"
  )

  x_minus_one <- c(
    "2023-08-22T13:13:14-01:00",
    "2020-01-01T00:02:03-01:00"
  )

  single_zero_offset <- "2023-08-22T14:13:14Z"

  single_offset <- "2023-08-22T15:13:14+01:00"

  withr::local_envvar(TZ = "America/New_York")
  expected <- as.POSIXct(strptime(
    c(
      "2023-08-22T14:13:14+0000",
      "2020-01-01T01:02:03+0000"
    ),
    format = "%Y-%m-%dT%H:%M:%S%z",
    tz = Sys.timezone()
  ))
  expect_identical(parse_connect_rfc3339(x_mixed), rep(expected, 2))
  expect_identical(parse_connect_rfc3339(x_zero_offset), expected)
  expect_identical(parse_connect_rfc3339(x_plus_one), expected)
  expect_identical(parse_connect_rfc3339(x_minus_one), expected)
  expect_identical(parse_connect_rfc3339(single_zero_offset), expected[1])
  expect_identical(parse_connect_rfc3339(single_offset), expected[1])

  withr::local_envvar(TZ = "UTC")
  expected <- as.POSIXct(strptime(
    c(
      "2023-08-22T14:13:14+0000",
      "2020-01-01T01:02:03+0000"
    ),
    format = "%Y-%m-%dT%H:%M:%S%z",
    tz = Sys.timezone()
  ))
  expect_identical(parse_connect_rfc3339(x_mixed), rep(expected, 2))
  expect_identical(parse_connect_rfc3339(x_zero_offset), expected)
  expect_identical(parse_connect_rfc3339(x_plus_one), expected)
  expect_identical(parse_connect_rfc3339(x_minus_one), expected)
  expect_identical(parse_connect_rfc3339(single_zero_offset), expected[1])
  expect_identical(parse_connect_rfc3339(single_offset), expected[1])

  withr::local_envvar(TZ = "Asia/Tokyo")
  expected <- as.POSIXct(strptime(
    c(
      "2023-08-22T14:13:14+0000",
      "2020-01-01T01:02:03+0000"
    ),
    format = "%Y-%m-%dT%H:%M:%S%z",
    tz = Sys.timezone()
  ))
  expect_identical(parse_connect_rfc3339(x_mixed), rep(expected, 2))
  expect_identical(parse_connect_rfc3339(x_zero_offset), expected)
  expect_identical(parse_connect_rfc3339(x_plus_one), expected)
  expect_identical(parse_connect_rfc3339(x_minus_one), expected)
  expect_identical(parse_connect_rfc3339(single_zero_offset), expected[1])
  expect_identical(parse_connect_rfc3339(single_offset), expected[1])
})


test_that("parse_connect_rfc3339() handles fractional seconds", {
  withr::local_envvar(TZ = "UTC")
  expected <- as.POSIXct(strptime(
    c(
      "2024-12-06T19:09:29.948016766+0000",
      "2024-12-06T19:09:29.948070345+0000"
    ),
    format = "%Y-%m-%dT%H:%M:%OS%z",
    tz = Sys.timezone()
  ))

  x <- c("2024-12-06T19:09:29.948016766Z", "2024-12-06T19:09:29.948070345Z")

  expect_identical(parse_connect_rfc3339(x), expected)
})

test_that("make_timestamp produces expected output", {
  x_mixed <- c(
    "2023-08-22T14:13:14Z",
    "2020-01-01T01:02:03Z",
    "2023-08-22T15:13:14+01:00",
    "2020-01-01T00:02:03-01:00"
  )

  x_zero_offset <- c(
    "2023-08-22T14:13:14Z",
    "2020-01-01T01:02:03Z"
  )

  x_plus_one <- c(
    "2023-08-22T15:13:14+01:00",
    "2020-01-01T02:02:03+01:00"
  )

  x_minus_one <- c(
    "2023-08-22T13:13:14-01:00",
    "2020-01-01T00:02:03-01:00"
  )

  single_zero_offset <- "2023-08-22T14:13:14Z"

  single_offset <- "2023-08-22T15:13:14+01:00"

  outcome <- c(
    "2023-08-22T14:13:14Z",
    "2020-01-01T01:02:03Z"
  )

  withr::local_envvar(TZ = "America/New_York")
  expect_equal(
    make_timestamp(coerce_datetime(x_mixed)),
    rep(outcome, 2)
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_zero_offset)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_plus_one)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_minus_one)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_zero_offset)),
    outcome[1]
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_offset)),
    outcome[1]
  )
  expect_equal(make_timestamp(outcome), outcome)

  withr::local_envvar(TZ = "UTC")
  expect_equal(
    make_timestamp(coerce_datetime(x_mixed)),
    rep(outcome, 2)
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_zero_offset)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_plus_one)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_minus_one)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_zero_offset)),
    outcome[1]
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_offset)),
    outcome[1]
  )
  expect_equal(make_timestamp(outcome), outcome)

  withr::local_envvar(TZ = "Asia/Tokyo")
  expect_equal(
    make_timestamp(coerce_datetime(x_mixed)),
    rep(outcome, 2)
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_zero_offset)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_plus_one)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_minus_one)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_zero_offset)),
    outcome[1]
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_offset)),
    outcome[1]
  )
  expect_equal(make_timestamp(outcome), outcome)
})

test_that("make_timestamp is safe for strings", {
  expect_equal(make_timestamp("hello"), "hello")
  expect_equal(make_timestamp(rep("hello", 5)), rep("hello", 5))

  expect_equal(make_timestamp(NA_character_), NA_character_)
})

test_that("make_timestamp converts POSIXct to character", {
  na_posixct <- as.POSIXct(NA, tz = Sys.timezone())
  expect_type(make_timestamp(na_posixct), "character")
})

test_that("parse_connectapi handles mixed null/non-null character values", {
  data <- list(
    list(guid = "aaa", bundle_id = NULL, name = "first"),
    list(guid = "bbb", bundle_id = "123", name = "second")
  )

  result <- parse_connectapi(data)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 2)
  expect_type(result$bundle_id, "character")
  expect_identical(result$bundle_id, c(NA_character_, "123"))
})

test_that("parse_connectapi handles mixed null/non-null datetime strings", {
  data <- list(
    list(guid = "aaa", active_time = NULL),
    list(guid = "bbb", active_time = "2023-08-22T14:13:14Z")
  )

  result <- parse_connectapi(data)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 2)
  expect_type(result$active_time, "character")
  expect_identical(result$active_time, c(NA_character_, "2023-08-22T14:13:14Z"))
})

test_that("parse_connectapi handles mixed null/non-null integer timestamps", {
  data <- list(
    list(key = "abc", start_time = 1732573574, end_time = NULL),
    list(key = "def", start_time = 1732553145, end_time = 1732556770)
  )

  result <- parse_connectapi(data)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 2)
  expect_type(result$end_time, "double")
  expect_identical(result$end_time, c(NA_real_, 1732556770))
})

test_that("parse_connectapi_typed converts datetime columns", {
  data <- list(
    list(guid = "aaa", created_time = "2023-08-22T14:13:14Z"),
    list(guid = "bbb", created_time = "2020-01-01T01:02:03Z")
  )

  result <- parse_connectapi_typed(data, c("created_time"))
  expect_s3_class(result, "tbl_df")
  expect_s3_class(result$created_time, "POSIXct")
  expect_type(result$guid, "character")
})

test_that("parse_connectapi_typed leaves non-datetime columns alone", {
  data <- list(
    list(guid = "aaa", name = "first"),
    list(guid = "bbb", name = "second")
  )

  result <- parse_connectapi_typed(data, character())
  expect_s3_class(result, "tbl_df")
  expect_type(result$guid, "character")
  expect_type(result$name, "character")
})
