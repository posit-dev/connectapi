with_mock_api({
  test_that("content environment vars", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    item <- content_item(con, "f2f37341-e21d-3d80-c698-a935ad614066")

    expect_GET(
      item$environment(),
      "https://connect.example/__api__/v1/content/f2f37341-e21d-3d80-c698-a935ad614066/environment"
    )
    expect_PATCH(
      item$environment_set(VAR_NAME = "new_value"),
      "https://connect.example/__api__/v1/content/f2f37341-e21d-3d80-c698-a935ad614066/environment",
      '[{"name":"VAR_NAME","value":"new_value"}]'
    )
    expect_PATCH(
      item$environment_set(VAR_NAME = NA),
      "https://connect.example/__api__/v1/content/f2f37341-e21d-3d80-c698-a935ad614066/environment",
      '[{"name":"VAR_NAME","value":null}]'
    )
    expect_PUT(
      item$environment_all(VAR_NAME = "new_value"),
      "https://connect.example/__api__/v1/content/f2f37341-e21d-3d80-c698-a935ad614066/environment",
      '[{"name":"VAR_NAME","value":"new_value"}]'
    )
    expect_PUT(
      item$environment_all(),
      "https://connect.example/__api__/v1/content/f2f37341-e21d-3d80-c698-a935ad614066/environment",
      "[]"
    )
  })

  test_that("env var function wrappers", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    item <- content_item(con, "34567890-e21d-3d80-c698-a935ad614066")

    expect_PATCH(
      set_environment_remove(item, var_to_remove),
      "https://connect.example/__api__/v1/content/34567890/environment",
      '[{"name":"var_to_remove","value":null}]'
    )
    expect_PATCH(
      set_environment_remove(item, one, another),
      "https://connect.example/__api__/v1/content/34567890/environment",
      '[{"name":"one","value":null},{"name":"another","value":null}]'
    )
    expect_PATCH(
      set_environment_remove(item, "var_to_remove"),
      "https://connect.example/__api__/v1/content/34567890/environment",
      '[{"name":"var_to_remove","value":null}]'
    )
  })
})
