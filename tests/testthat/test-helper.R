test_that("expect_rlib_warning matches expected warning", {
  f1 <- function() {
    warn_once("a warning", id = "abcdefg")
  }
  f2 <- function() NULL
  withr::with_options(
    list(rlib_warning_verbosity = "verbose"),
    {
      expect_rlib_warning(f1(), "a warning")
      expect_error(expect_rlib_warning(f1(), "non-matching warning"))
      expect_rlib_warning(f2(), "a warning")
    })
})
