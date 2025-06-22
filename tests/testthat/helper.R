expect_rlib_warning <- function(code, regexp = NULL, envir = parent.frame()) {
  withr::with_options(
    list(rlib_warning_verbosity = "verbose"),
    res <- withCallingHandlers(eval(code, envir = envir), warning = function(w) {
      if (is.null(regexp) || grepl(regexp, conditionMessage(w))) {
        invokeRestart("muffleWarning")
      } else {
        stop(glue::glue("Warning did not match expected warning message ({regexp}). Got: {conditionMessage(w)}"))
      }
    })
  )
  invisible(res)
}
