test_that("expect_rlib_warning matches expected warning", {
  f1 <- function() {
    warn_once("a warning", id = "abcdefg")
  }
  f2 <- function() NULL
  withr::with_options(
    list(rlib_warning_verbosity = "verbose"),
    {
      expect_rlib_warning(f1())
      expect_rlib_warning(f1(), "a warning")
      # because the warning doesn't match it bubbles up into the output, so we
      # suppress it with suppressWarnings:
      suppressWarnings(expect_error(expect_rlib_warning(f1(), "non-matching warning")))
      expect_error(expect_rlib_warning(f2(), "a warning"))
    })
})

test_that("expect_rlib_warning errors if warning isn't thrown", {
  f1 <- function() {
    1 + 1
  }
  f2 <- function() {
    message("a")
    message("b")
  }

  expect_error(expect_rlib_warning(f1()))
  suppressMessages(expect_error(expect_rlib_warning(f2())))
})

test_that("expect_rlib_warning also works with regular warnings", {
  f1 <- function() {
    warning("a warning")
  }
  expect_rlib_warning(f1())
  expect_rlib_warning(f1(), "a warning")
})

test_that("expect_rlib_warning does not affect warning state outside its scope", {
  f1 <- function() {
    warn_once("a warning", id = "hijklmnop")
  }

  withr::defer(rlang::reset_warning_verbosity("hijklmnop"))
  withr::with_options(
    list(rlib_warning_verbosity = "default"),
    {
      expect_rlib_warning(f1(), "a warning")
      # still produces a warning even though one was produced in the call to
      # expect_rlib_warning()
      expect_warning(f1(), "a warning")
      expect_no_warning(f1())
    }
  )
})
