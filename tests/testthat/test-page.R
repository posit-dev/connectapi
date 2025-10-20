with_mock_dir("2025.09.0", {
  client <- Connect$new(
    server = "https://connect.example",
    api_key = "not-a-key"
  )

  test_that("page_offset respects a specified 'limit' ", {
    # These mocks return four results across two pages.
    res <- search_content(client, q = "blobfish", limit = 3)
    expect_equal(length(res), 3)
    expect_equal(
      purrr::map_chr(res, list("content", "title")),
      c("blobfish dashboard", "blobfish api", "blobfish report")
    )
  })
})
