with_mock_dir("2024.12.0", {
  test_that("get_integrations() gets integrations", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    integrations <- get_integrations(client)
    expect_s3_class(integrations, "connect_integration_list")

    expect_equal(integrations[[1]]$name, "GitHub Integration")
    expect_equal(integrations[[2]]$updated_time, "2025-03-25T19:07:01Z")
    expect_equal(integrations[[1]]$config$client_id, "client_id_123")
    expect_s3_class(integrations[[1]], "connect_integration")
  })

  test_that("get_integrations() can be converted to a data frame correctly", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    integrations_df <- get_integrations(client) |>
      as_tibble()
    expect_named(
      integrations_df,
      c(
        "id",
        "guid",
        "created_time",
        "updated_time",
        "name",
        "description",
        "template",
        "auth_type",
        "config"
      )
    )
    expect_equal(
      integrations_df$description,
      c(
        "with refresh support ",
        "The service provides utility to your company"
      )
    )
  })
})

test_that("get_integrations() errs on older Connect versions", {
  client <- MockConnect$new("2024.11.1")
  client$version
  expect_error(
    get_integrations(client),
    "This feature requires Posit Connect version 2024.12.0 but you are using 2024.11.1"
  )
})

test_that("as_integration correctly converts lists to integration objects", {
  valid_integration <- list(
    id = "123",
    guid = "abc-123",
    created_time = Sys.time(),
    updated_time = Sys.time(),
    name = "Test Integration",
    description = "A test integration",
    template = "github",
    auth_type = "oauth2",
    config = list(client_id = "client_id")
  )

  result <- as_integration(valid_integration)
  expect_s3_class(result, "connect_integration")
  expect_identical(result$guid, valid_integration$guid)
})

test_that("as_integration.default errors on non-list input", {
  expect_error(as_integration(42), "Cannot convert object of class")
  expect_error(
    as_integration("string"),
    "Cannot convert object of class"
  )
})

test_that("print.integration produces expected output", {
  test_int <- structure(
    list(
      name = "Test Integration",
      guid = "abc-123",
      template = "github"
    ),
    class = c("connect_integration", "list")
  )

  output <- capture.output(result <- print(test_int))

  expect_match(output[1], "Integration: Test Integration")
  expect_match(output[2], "GUID: abc-123")
  expect_match(output[3], "Template: github")
  expect_identical(result, test_int)
})

with_mock_dir("2024.12.0", {
  test_that("integration creates a single integration", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    x <- get_integration(client, "f8688548")
    expect_s3_class(x, "connect_integration")
    expect_equal(x$template, "custom")
    expect_equal(x$guid, "f8688548")
  })
})

test_that("set_integrations() sends expected request", {
  with_mock_dir("2024.12.0", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    x <- content_item(client, "12345678")
    y <- get_integration(client, "f8688548")
  })
  without_internet(
    expect_PUT(
      set_integrations(x, y),
      url = "https://connect.example/__api__/v1/content/12345678/oauth/integrations/associations",
      '[{"oauth_integration_guid":"f8688548"}]'
    )
  )
})

test_that("set_integrations() fails when provided the wrong class", {
  with_mock_dir("2024.12.0", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    x <- content_item(client, "12345678")
  })
  expect_error(
    set_integrations(x, "string"),
    "`integrations` must be a `connect_integration` class object, a list, or NULL"
  )
  expect_error(
    set_integrations(x, list("string")),
    "All items must be `connect_integration` objects"
  )
})

with_mock_dir("2025.07.0", {
  test_that("get_integrations() works with Content objects", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    content <- content_item(client, "12345678")
    integrations <- get_integrations(content)

    expect_s3_class(integrations, "connect_integration_list")
    expect_equal(length(integrations), 2)
    expect_equal(integrations[[1]]$name, "Integration 1")
    expect_equal(integrations[[2]]$template, "template2")
    expect_s3_class(integrations[[1]], "connect_integration")
  })
})

test_that("get_integrations() with Content errs on older Connect versions", {
  client <- MockConnect$new("2024.11.1")
  content <- Content$new(
      connect = client,
      content = list(guid = "12345678")
  )
  expect_error(
    get_integrations(content),
    "This feature requires Posit Connect version 2024.12.0 but you are using 2024.11.1"
  )
})

test_that("get_integrations() fails when provided the wrong class", {
  expect_error(
    get_integrations("string"),
    "`x` must be a Connect or Content object"
  )
  expect_error(
    get_integrations(list()),
    "`x` must be a Connect or Content object"
  )
})
