# Temporarily skip these on newer Connect versions because the manifest for this
# content specifies an old version of R not found in newer images.
skip_if(safe_server_version(client) > "2024.03.0")

# ensure that RSPM is being used so these do not take eternity
shiny_content <- deploy_example(client, "shiny")

test_that("set_run_as works with a good linux user", {
  scoped_experimental_silence()
  res <- set_run_as(shiny_content, "rstudio-connect")
  expect_equal(
    res$content$run_as,
    "rstudio-connect"
  )

  skip("TODO: failing because of a bug in Connect")
  res2 <- set_run_as(shiny_content, NULL)
  expect_null(res2$content$run_as)
})

test_that("set_run_as fails with a bad linux user", {
  scoped_experimental_silence()
  expect_error(
    suppressMessages(
      set_run_as(shiny_content, "fake-user")
    ),
    "400"
  )
})

test_that("set_run_as works for run_as_current_user", {
  scoped_experimental_silence()
  res <- set_run_as(
    shiny_content,
    run_as = NULL,
    run_as_current_user = TRUE
  )

  expect_true(
    shiny_content$content$run_as_current_user
  )

  res2 <- set_run_as(
    shiny_content,
    run_as = NULL,
    run_as_current_user = FALSE
  )

  expect_false(
    shiny_content$content$run_as_current_user
  )
})
