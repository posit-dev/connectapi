# Checks that an expected warning was thrown.
#
# This function is more robust than `expect_warning()` because it locally sets
# the `rlib_warning_verbosity` option to "verbose". Without this option, we can
# see inconsistent test behavior if the verbosity is "default" and the state is
# not reset after a test. Additionally, this function lets us check for a
# specific regex match in the warning message while still returning the output
# of the evaluated code (`testthat::expect_warning()` only returns the result if
# the regexp is NA, otherwise it returns the captured condition).
expect_rlib_warning <- function(object, regexp = NULL, envir = parent.frame()) {
  pass <- FALSE

  result <- withr::with_options(
    list(rlib_warning_verbosity = "verbose"),
    withCallingHandlers(
      eval(object, envir = envir),
      warning = function(w) {
        if (is.null(regexp) || grepl(regexp, conditionMessage(w))) {
          pass <<- TRUE
          invokeRestart("muffleWarning")
        }
      }
    )
  )

  expect(isTRUE(pass), "Code did not produce the expected warning")
  invisible(result)
}
