without_internet({
  test_that("Querying groups by prefix", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_GET(
      client$groups(prefix = "TEST"),
      "https://connect.example/__api__/v1/groups?page_number=1&page_size=500&prefix=TEST"
    )

    # Now with spaces
    expect_GET(
      client$groups(prefix = "A Group Name", page_size = 5),
      "https://connect.example/__api__/v1/groups?page_number=1&page_size=5&prefix=A%20Group%20Name"
    )

    # Now with too big page size: it automatically truncates (maybe that's bad)
    expect_GET(
      client$groups(page_size = 1000),
      "https://connect.example/__api__/v1/groups?page_number=1&page_size=500"
    )
  })

  test_that("Querying remote groups", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_GET(
      client$groups_remote(),
      "https://connect.example/__api__/v1/groups/remote?limit=500"
    )
    expect_GET(
      client$groups_remote(prefix = "A group name"),
      "https://connect.example/__api__/v1/groups/remote?limit=500&prefix=A%20group%20name"
    )
    expect_GET(
      client$groups_remote(limit = 1000),
      "https://connect.example/__api__/v1/groups/remote?limit=500"
    )
  })
})

with_mock_api({
  client <- connect(server = "https://connect.example", api_key = "fake")
  test_that("get_groups() paginates with no prefix", {
    # To get this result, the code has to paginate through two API requests.
    # groups-4eaf46.json
    # groups-125d47.json

    result <- get_groups(client, page_size = 5, limit = 10)
    expected_names <- c(
      "~!@#$%^&*()_+",
      "1111",
      "2_viewer_group",
      "amanda_test_group",
      "a_new_group",
      "azurepipelines",
      "cgGroup01",
      "chris_test_group",
      "connect_dev",
      "cool_kids_of_the_dmv"
    )
    expect_identical(result$name, expected_names)
  })

  test_that("get_groups() does not paginate when called with a prefix", {
    # Only one response exists for this query; by succeeding this test verifies
    # that the pagination behavior is not engaged.
    # groups-deae1f.json

    result <- get_groups(client, page_size = 2, prefix = "c")
    expect_identical(result$name, c("connect_dev", "cool_kids_of_the_dmv"))
  })
})

with_mock_api({
  client <- Connect$new(
    server = "https://connect.example",
    api_key = "not-a-key"
  )

  test_that("get_group_content() works", {
    group_guids <- c(
      "a6fb5cea",
      "ae5c3b2c"
    )

    expect_snapshot(get_group_content(client, group_guids))
  })

  test_that("get_group_content() returns an empty data frame when no content exists", {
    group_guid <- "a6fb5cff"

    expect_snapshot(get_group_content(client, group_guid))
  })
})
