test_that("swap_vanity_urls() fails gracefully", {
  with_mock_api({
    client <- connect(server = "https://connect.example", api_key = "fake")

    works <- content_item(client, "951bf3ad")
    fails <- content_item(client, "c3426b0b")

    expect_error(
      expect_rlib_warning(swap_vanity_urls(fails, works)),
      paste(
        "Unable to modify the vanity URL for content_a:",
        "https://connect\\.example/__api__/v1/content/c3426b0b/vanity",
        "request failed with Client error: \\(403\\) Forbidden"
      )
    )
    expect_error(
      expect_rlib_warning(swap_vanity_urls(works, fails)),
      paste(
        "Unable to modify the vanity URL for content_b:",
        "https://connect\\.example/__api__/v1/content/c3426b0b/vanity",
        "request failed with Client error: \\(403\\) Forbidden"
      )
    )
  })
})
