# Temporarily skip these on newer Connect versions because the manifest for this
# content specifies an old version of R not found in newer images.
skip_if(safe_server_version(client) > "2024.03.0")

# ensure that RSPM is being used so these do not take eternity
rmd_content <- deploy_example(client, "rmarkdown")

# TODO: very hard to test parameterized rmarkdown because creating a
# programmatic variant is not possible

test_that("get_variants works", {
  scoped_experimental_silence()
  vrs <- get_variants(rmd_content)

  expect_equal(nrow(vrs), 1)

  vr <- get_variant(rmd_content, vrs$key)
  expect_true(validate_R6_class(vr, "Variant"))
})

test_that("variant_render works", {
  scoped_experimental_silence()
  vr <- get_variant_default(rmd_content)

  rnd <- variant_render(vr)
  rnd2 <- variant_render(vr)

  expect_true(validate_R6_class(rnd, "VariantTask"))
  # TODO: would be great to be able to "tail the logs", for instance
  # i.e. actually reference the "job" itself...

  # wait for tasks to complete...
  suppressMessages(poll_task(rnd))
  suppressMessages(poll_task(rnd2))
})

test_that("content_render works", {
  rnd <- content_render(rmd_content)

  expect_true(validate_R6_class(rnd, "VariantTask"))

  # wait for tasks to complete...
  suppressMessages(poll_task(rnd))
})

test_that("get_variant_renderings works", {
  scoped_experimental_silence()

  vr <- get_variant_default(rmd_content)

  rnd <- get_variant_renderings(vr)

  expect_gt(nrow(rnd), 1)
})

test_that("get_jobs works", {
  scoped_experimental_silence()
  vr <- get_variant_default(rmd_content)

  all_jobs <- get_jobs(vr)
  expect_gt(nrow(all_jobs), 1)
})
