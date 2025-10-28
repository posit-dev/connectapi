# Temporarily skip these on newer Connect versions because the manifest for this
# content specifies an old version of R not found in newer images.
skip_if(safe_server_version(client) > "2024.03.0")

# ensure that RSPM is being used so these do not take eternity
rmd_content <- deploy_example(client, "rmarkdown")

test_that("get_environment works with no environment variables", {
  env <- get_environment(rmd_content)
  curr_vers <- env$env_version
  env <- get_environment(rmd_content)

  expect_identical(env$env_vars, list())
})

test_that("set_environment works", {
  scoped_experimental_silence()
  env <- get_environment(rmd_content)

  new_env <- set_environment_new(
    env,
    test = "value",
    test1 = TRUE,
    test2 = 4567
  )

  expect_equal(
    new_env$env_vars,
    list(
      "test",
      "test1",
      "test2"
    )
  )

  new_env1 <- set_environment_new(env, test1 = "another")
  expect_equal(
    new_env$env_vars,
    list(
      "test",
      "test1",
      "test2"
    )
  )

  # remove a value multiple times
  rm1 <- set_environment_remove(env, test)
  expect_equal(rm1$env_vars, list("test1", "test2"))
  rm2 <- set_environment_remove(env, test)
  expect_equal(rm1$env_vars, list("test1", "test2"))

  rm3 <- set_environment_remove(env, "test1")
  expect_equal(rm3$env_vars, list("test2"))

  rm4 <- set_environment_remove(env, "test2")
  expect_equal(rm4$env_vars, list())
})

test_that("add environment variable works", {
  res <- set_environment_new(rmd_content, MYVAR = "hi")
  expect_true("MYVAR" %in% res$env_vars)
  expect_true(validate_R6_class(res, "Environment"))
})

test_that("edit environment variable works", {
  res <- set_environment_new(rmd_content, MYVAR = "hi", OTHER = "other")
  res2 <- set_environment_new(rmd_content, MYVAR = "hi2")
  expect_true("MYVAR" %in% res2$env_vars)
  expect_true("OTHER" %in% res2$env_vars)
  expect_true(validate_R6_class(res2, "Environment"))
})

test_that("get environment works", {
  res <- set_environment_new(rmd_content, MYVAR = "hi")
  res <- get_environment(rmd_content)
  expect_true("MYVAR" %in% res$env_vars)
  expect_true(validate_R6_class(res, "Environment"))
})

test_that("remove environment variable works", {
  res <- set_environment_new(rmd_content, MYVAR = "hi", ANOTHER = "how")
  rem <- set_environment_new(rmd_content, MYVAR = NA)

  expect_false("MYVAR" %in% rem$env_vars)
  expect_true("ANOTHER" %in% rem$env_vars)
  expect_true(validate_R6_class(res, "Environment"))

  res <- set_environment_remove(rmd_content, ANOTHER)
  expect_false("ANOTHER" %in% res$env_vars)

  res <- set_environment_new(rmd_content, MYVAR = "hi", ANOTHER = "how")
  myvar <- c("MYVAR", "ANOTHER")
  res <- set_environment_remove(rmd_content, !!myvar)
  expect_false("ANOTHER" %in% res$env_vars)
  expect_false("MYVAR" %in% res$env_vars)

  res <- set_environment_new(rmd_content, MYVAR = "hi", ANOTHER = "how")
  myvar <- c("MYVAR", "ANOTHER")
  res <- set_environment_remove(rmd_content, !!!myvar)
  expect_false("ANOTHER" %in% res$env_vars)
  expect_false("MYVAR" %in% res$env_vars)

  res <- set_environment_new(rmd_content, MYVAR = "hi", ANOTHER = "how")
  myvar <- c("MYVAR" = "1", "ANOTHER" = "2")
  res <- set_environment_remove(rmd_content, !!!myvar)
  expect_false("ANOTHER" %in% res$env_vars)
  expect_false("MYVAR" %in% res$env_vars)

  res <- set_environment_new(rmd_content, MYVAR = "hi", ANOTHER = "how")
  myvar <- c("MYVAR" = "1", "ANOTHER" = "2")
  res <- set_environment_remove(rmd_content, !!myvar)
  expect_true("ANOTHER" %in% res$env_vars)
  expect_true("MYVAR" %in% res$env_vars)
})

test_that("set all environment variables works", {
  res <- set_environment_all(rmd_content)
  expect_true(length(res$env_vars) == 0)
  expect_true(validate_R6_class(res, "Environment"))

  res <- set_environment_all(rmd_content, "MYVAR" = "ONE", "ANOTHER" = "HELLO")
  expect_equal(res$env_vars, list("ANOTHER", "MYVAR"))
  expect_true(validate_R6_class(res, "Environment"))

  res <- set_environment_all(rmd_content, "MYVAR" = "TWO", "HELLO" = "AGAIN")
  expect_equal(res$env_vars, list("HELLO", "MYVAR"))
  expect_true(validate_R6_class(res, "Environment"))

  res <- set_environment_all(rmd_content)
  expect_true(length(res$env_vars) == 0)
  expect_true(validate_R6_class(res, "Environment"))
})
