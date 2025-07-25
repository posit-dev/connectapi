test_that("Connect R6 class preserves provided values", {
  server <- "http://myhost.example.com"
  api_key <- "fake"

  con <- Connect$new(server = server, api_key = api_key)

  expect_identical(con$server, server)
  expect_identical(con$api_key, api_key)
})

test_that("trailing slash removed from server", {
  con <- Connect$new(server = "http://myhost.example.com/", api_key = "fake")
  con2 <- Connect$new(server = "http://myhost.example.com", api_key = "fake")

  expect_identical(con$server, con2$server)
})

test_that("error if protocol not defined", {
  con <- Connect$new(server = "https://myhost.example.com", api_key = "fake")

  expect_error(
    Connect$new("test.example.com", "fake"),
    "protocol"
  )

  expect_error(
    Connect$new("://test.example.com", "fake"),
    "protocol"
  )
})

test_that("version is validated", {
  skip("not implemented yet")
})

test_that("Handling error responses", {
  con <- Connect$new(server = "https://connect.example", api_key = "fake")
  resp <- fake_response(
    "https://connect.example/__api__/",
    headers = list(`Content-Type` = "application/json; charset=utf-8"),
    status_code = 400L,
    content = list(code = 3, error = "Invalid GUID: abc", payload = NULL)
  )
  expect_error(
    con$raise_error(resp),
    "request failed with Client error: \\(400\\) Bad Request \\(code: 3, error: Invalid GUID: abc\\)"
  )
})

test_that("Handling error responses without all expected fields", {
  con <- Connect$new(server = "https://connect.example", api_key = "fake")
  resp1 <- fake_response(
    "https://connect.example/__api__/",
    headers = list(`Content-Type` = "application/json; charset=utf-8"),
    status_code = 400L,
    content = list(code = 3L)
  )
  resp2 <- fake_response(
    "https://connect.example/__api__/",
    headers = list(`Content-Type` = "application/json; charset=utf-8"),
    status_code = 400L,
    content = list(error = "Invalid GUID: abc")
  )
  resp3 <- fake_response(
    "https://connect.example/__api__/",
    headers = list(`Content-Type` = "application/json; charset=utf-8"),
    status_code = 400L,
    content = NULL
  )
  expect_error(
    con$raise_error(resp1),
    "request failed with Client error: \\(400\\) Bad Request \\(code: 3\\)"
  )
  expect_error(
    con$raise_error(resp2),
    "request failed with Client error: \\(400\\) Bad Request \\(error: Invalid GUID: abc\\)"
  )
  expect_error(
    con$raise_error(resp3),
    "request failed with Client error: \\(400\\) Bad Request $"
  )
})

test_that("Handling deprecation warnings", {
  rlang::reset_warning_verbosity("X-Deprecated-Endpoint")
  on.exit(rlang::reset_warning_verbosity("X-Deprecated-Endpoint"))

  # No warning here
  resp <- fake_response(
    "https://connect.example/__api__/",
    headers = list(
      `Content-Type` = "application/json; charset=utf-8"
    )
  )
  expect_warning(check_debug(resp), NA)

  withr::with_options(
    list(rlib_warning_verbosity = "default"), {

      # Yes warning here
      resp <- fake_response(
        "https://connect.example/__api__/",
        headers = list(
          `X-Deprecated-Endpoint` = "/v1",
          `Content-Type` = "application/json; charset=utf-8"
        )
      )
      expect_warning(
        check_debug(resp),
        paste(
          "https://connect.example/__api__/ is deprecated and will be removed in a",
          "future version of Connect. Please upgrade `connectapi` in order to use",
          "the new APIs."
        ),
        class = "deprecatedWarning"
      )
      # No warning if you do it again because we only warn the first time
      expect_warning(check_debug(resp), NA)
    }
  )
})

with_mock_api({
  test_that("browse URLs", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    # Inject into this function something other than utils::browseURL
    # so we can assert that it is being called without actually trying to open a browser
    suppressMessages(trace(
      "browse_url",
      where = connectapi::browse_solo,
      tracer = quote({
        browseURL <- # nolint: object_name_linter
          function(x) {
            warning(paste("Opening", x))
          }
      }),
      at = 1,
      print = FALSE
    ))
    expect_warning(
      browse_connect(con),
      "Opening https://connect.example"
    )
    expect_warning(
      browse_api_docs(con),
      "Opening https://connect.example/__docs__/api"
    )
    suppressMessages(untrace("browse_url", where = connectapi::browse_solo))
  })

  test_that("httr_config", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    con$httr_config(httr::add_headers(MY_MAGIC_HEADER = "value"))
    expect_header(
      expect_GET(
        con$GET("v1/content"),
        "https://connect.example/__api__/v1/content"
      ),
      "MY_MAGIC_HEADER: value"
    )
  })

  test_that("client$version is NA when server settings lacks version info", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    v <- con$version
    expect_true(is.na(v))
  })
})

test_that("client$version is returns version when server settings exposes it", {
  with_mock_dir("2024.09.0", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_equal(con$version, "2024.09.0")
  })
})

test_that("Visitor client can successfully be created running on Connect", {
  with_mock_api({
    withr::local_options(list(rlib_warning_verbosity = "verbose"))
    withr::local_envvar(
      CONNECT_SERVER = "https://connect.example",
      CONNECT_API_KEY = "fake",
      RSTUDIO_PRODUCT = "CONNECT"
    )

    expect_warning(
      client <- connect(token = "my-token"),
      "This feature requires Posit Connect version"
    )

    expect_equal(
      client$server,
      "https://connect.example"
    )
    expect_equal(
      client$api_key,
      "visitor-api-key"
    )
  })
})

test_that("Visitor client can successfully be created running on Connect with audience", {
  with_mock_dir("2025.07.0", {
    withr::local_options(list(rlib_warning_verbosity = "verbose"))
    withr::local_envvar(
      CONNECT_SERVER = "https://connect.example",
      CONNECT_API_KEY = "fake",
      RSTUDIO_PRODUCT = "CONNECT"
    )

    client <- connect(token = "my-token", audience = "audience")

    expect_equal(
      client$server,
      "https://connect.example"
    )
    expect_equal(
      client$api_key,
      "visitor-api-key"
    )
  })
})

test_that("Visitor client uses fallback api key when running locally", {
  with_mock_api({
    withr::local_options(list(rlib_warning_verbosity = "verbose"))
    withr::local_envvar(
      CONNECT_SERVER = "https://connect.example",
      CONNECT_API_KEY = "fake"
    )

    # With default fallback
    expect_warning(
      expect_message(
        client <- connect(token = NULL),
        "Called with `token` but not running on Connect. Continuing with fallback API key."
      ),
      "the server version is not exposed by this Posit Connect instance"
    )

    expect_equal(
      client$server,
      "https://connect.example"
    )
    expect_equal(
      client$api_key,
      "fake"
    )

    # With explicitly-defined fallback
    expect_warning(
      expect_message(
        client <- connect(
          token = NULL,
          token_local_testing_key = "fallback_fake"
        ),
        "Called with `token` but not running on Connect. Continuing with fallback API key."
      ),
      "the server version is not exposed by this Posit Connect instance"
    )

    expect_equal(
      client$server,
      "https://connect.example"
    )
    expect_equal(
      client$api_key,
      "fallback_fake"
    )
  })
})

test_that("Visitor client code path errs with older Connect version", {
  with_mock_dir("2024.09.0", {
    withr::local_envvar(
      CONNECT_SERVER = "https://connect.example",
      CONNECT_API_KEY = "fake",
      RSTUDIO_PRODUCT = "CONNECT"
    )

    expect_error(
      client <- connect(token = "my-token"),
      "This feature requires Posit Connect version 2025.01.0 but you are using 2024.09.0"
    )
  })
})

test_that("Scientific notation is not used for reasonable parameters", {
  with_mock_api({
    test_scipen <- 5
    withr::local_options(
      rlib_warning_verbosity = "quiet",
      scipen = test_scipen
    )

    client <- Connect$new(server = "https://connect.example", api_key = "fake")

    expect_GET(
      get_packages(client, page_size = 999999999),
      "https://connect.example/__api__/v1/packages?page_number=1&page_size=999999999"
    )
    expect_equal(getOption("scipen"), test_scipen)
  })
})
