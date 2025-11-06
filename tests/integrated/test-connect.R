# This whole suite assumes CONNECT_SERVER and CONNECT_API_KEY env vars are set
test_that("connect() works", {
  expect_true(validate_R6_class(connect(), "Connect"))
})

test_that("connect fails for good server, bad api key", {
  expect_error({
    connect(
      api_key = "bogus"
    )
  })
})
