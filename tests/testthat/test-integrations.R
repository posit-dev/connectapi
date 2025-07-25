with_mock_dir("2024.12.0", {
  test_that("get_integrations() gets integrations", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    integrations <- get_integrations(client)
    expect_true(inherits(integrations, "connect_list_integrations"))

    # Check a few fields
    expect_equal(integrations[[1]]$name, "GitHub Integration")
    expect_equal(integrations[[2]]$updated_time, "2025-03-25T19:07:01Z")
    expect_equal(integrations[[1]]$config$client_id, "client_id_123")
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
