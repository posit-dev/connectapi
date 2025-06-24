expect_rlib_warning <- function(object, regexp = NULL, envir = parent.frame()) {
  res <- withr::with_options(
    list(rlib_warning_verbosity = "verbose"),
    withCallingHandlers(eval(object, envir = envir), warning = function(w) {
      expect(
        is.null(regexp) || grepl(regexp, conditionMessage(w)),
        glue::glue(
          "Warning message did not match expected message. Expected: {regexp}, got: {conditionMessage(w)}"
        )
      )
      invokeRestart("muffleWarning")
    })
  )

  invisible(res)
}
