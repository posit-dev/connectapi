library(testthat)
library(connectapi)

multi_reporter <- MultiReporter$new(
  reporters = list(
    ProgressReporter$new(max_failures = 1000),
    CheckReporter$new(file = fs::path("check-results-check.txt"))
  )
)

test_check("connectapi", reporter = multi_reporter)
