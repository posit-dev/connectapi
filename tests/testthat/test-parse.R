test_that("coerce_fsbytes fills the void", {
  expect_s3_class(coerce_fsbytes(1L, fs::as_fs_bytes(NA_integer_)), "fs_bytes")
  expect_s3_class(coerce_fsbytes(1, fs::as_fs_bytes(NA_integer_)), "fs_bytes")
  expect_error(
    coerce_fsbytes(data.frame(), fs::as_fs_bytes(NA_integer_)),
    class = "vctrs_error_incompatible_type"
  )
})

test_that("coerce_datetime fills the void", {
  chardate <- "2023-10-25T17:04:08Z"
  numdate <- as.double(Sys.time())
  expect_s3_class(coerce_datetime(chardate, NA_datetime_), "POSIXct")
  expect_s3_class(
    coerce_datetime(c(chardate, chardate), NA_datetime_),
    "POSIXct"
  )
  expect_s3_class(coerce_datetime(numdate, NA_datetime_), "POSIXct")
  expect_s3_class(coerce_datetime(c(numdate, numdate), NA_datetime_), "POSIXct")
  expect_s3_class(coerce_datetime(NA_datetime_, NA_datetime_), "POSIXct")
  expect_s3_class(
    coerce_datetime(c(NA_datetime_, NA_datetime_), NA_datetime_),
    "POSIXct"
  )
  expect_s3_class(coerce_datetime(NA_integer_, NA_datetime_), "POSIXct")
  expect_s3_class(
    coerce_datetime(c(NA_integer_, NA_integer_), NA_datetime_),
    "POSIXct"
  )
  expect_s3_class(coerce_datetime(NA, NA_datetime_), "POSIXct")
  expect_s3_class(coerce_datetime(c(NA, NA), NA), "POSIXct")
  expect_s3_class(coerce_datetime(NULL, NA), "POSIXct")

  expect_error(
    coerce_datetime(data.frame(), NA_datetime_),
    class = "vctrs_error_incompatible_type"
  )
  expect_error(
    coerce_datetime(list(), NA_datetime_, name = "list"),
    class = "vctrs_error_incompatible_type"
  )

  expect_error(
    coerce_datetime(NA_complex_, NA_datetime_, name = "complexity"),
    class = "vctrs_error_incompatible_type"
  )
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
    make_timestamp(coerce_datetime(x_mixed, NA_datetime_)),
    rep(outcome, 2)
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_zero_offset, NA_datetime_)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_plus_one, NA_datetime_)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_minus_one, NA_datetime_)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_zero_offset, NA_datetime_)),
    outcome[1]
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_offset, NA_datetime_)),
    outcome[1]
  )
  expect_equal(make_timestamp(outcome), outcome)

  withr::local_envvar(TZ = "UTC")
  expect_equal(
    make_timestamp(coerce_datetime(x_mixed, NA_datetime_)),
    rep(outcome, 2)
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_zero_offset, NA_datetime_)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_plus_one, NA_datetime_)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_minus_one, NA_datetime_)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_zero_offset, NA_datetime_)),
    outcome[1]
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_offset, NA_datetime_)),
    outcome[1]
  )
  expect_equal(make_timestamp(outcome), outcome)

  withr::local_envvar(TZ = "Asia/Tokyo")
  expect_equal(
    make_timestamp(coerce_datetime(x_mixed, NA_datetime_)),
    rep(outcome, 2)
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_zero_offset, NA_datetime_)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_plus_one, NA_datetime_)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(x_minus_one, NA_datetime_)),
    outcome
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_zero_offset, NA_datetime_)),
    outcome[1]
  )
  expect_equal(
    make_timestamp(coerce_datetime(single_offset, NA_datetime_)),
    outcome[1]
  )
  expect_equal(make_timestamp(outcome), outcome)
})

test_that("make_timestamp is safe for strings", {
  expect_equal(make_timestamp("hello"), "hello")
  expect_equal(make_timestamp(rep("hello", 5)), rep("hello", 5))

  expect_equal(make_timestamp(NA_character_), NA_character_)
})

test_that("make_timestamp converts to character", {
  expect_type(make_timestamp(NA_datetime_), "character")
})

test_that("ensure_column works with lists", {
  list_chk_null <- ensure_column(tibble::tibble(), NA_list_, "hello")
  expect_s3_class(list_chk_null, "tbl_df")
  expect_type(list_chk_null$hello, "list")

  list_chk_same <- ensure_column(
    tibble::tibble(hello = list(list(1, 2, 3), list(1, 2, 3, 4))),
    NA_list_,
    "hello"
  )
  expect_s3_class(list_chk_same, "tbl_df")
  expect_type(list_chk_same$hello, "list")
})

test_that("ensure_column works with POSIXct", {
  time_chk_null <- ensure_column(tibble::tibble(), NA_datetime_, "hello")
  expect_s3_class(time_chk_null, "tbl_df")
  expect_s3_class(time_chk_null$hello, "POSIXct")

  time_chk_some <- ensure_column(
    tibble::tibble(one = c(1, 2, 3)),
    NA_datetime_,
    "hello"
  )
  expect_s3_class(time_chk_some, "tbl_df")
  expect_s3_class(time_chk_some$hello, "POSIXct")

  skip("Ahh! this fails presently. Are double -> POSIXct conversions allowed?")
  time_chk_convert <- ensure_column(
    tibble::tibble(hello = c(1, 2, 3)),
    NA_datetime_,
    "hello"
  )
  expect_s3_class(time_chk_convert, "tbl_df")
  expect_s3_class(time_chk_convert$hello, "POSIXct")
})

test_that("converts length one list", {
  hm <- ensure_column(tibble::tibble(one = "hi"), NA_list_, "one")
  expect_type(hm$one, "list")
})
