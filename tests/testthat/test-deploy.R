test_that("bundle_dir errors if no manifest.json", {
  expect_error(
    suppressMessages(bundle_dir(rprojroot::find_testthat_root_file(
      "examples/no_manifest"
    ))),
    "no `manifest.json`"
  )
})

test_that("bundle_dir warns if packrat.lock", {
  expect_warning(
    suppressMessages(bundle_dir(rprojroot::find_testthat_root_file(
      "examples",
      "include_packrat_lock"
    ))),
    "`packrat.lock` file found"
  )
})

test_that("bundle_dir warns if packrat folder", {
  expect_warning(
    suppressMessages(bundle_dir(rprojroot::find_testthat_root_file(
      "examples",
      "include_packrat"
    ))),
    "`packrat` directory found"
  )
})

test_that("bundle_dir not fooled by subfolders", {
  expect_error(
    suppressMessages(bundle_dir(rprojroot::find_testthat_root_file(
      "examples",
      "include_multiple_folders"
    ))),
    "no `manifest.json`"
  )
})

test_that("bundle_dir works with relative paths", {
  bnd <- suppressMessages(bundle_dir(fs::path_rel(rprojroot::find_testthat_root_file(
    "examples",
    "doc"
  ))))
  expect_true(fs::file_exists(bnd$path))
})

test_that("bundle_dir errors for nonexistent paths", {
  expect_error(
    suppressMessages(
      bundle_dir(rprojroot::find_testthat_root_file(
        "examples",
        "does_not_exist_not_real"
      ))
    ),
    "not TRUE"
  )
})

test_that("swap_vanity_urls() fails gracefully", {
  with_mock_api({
    client <- connect(server = "https://connect.example", api_key = "fake")

    works <- content_item(client, "951bf3ad")
    fails <- content_item(client, "c3426b0b")

    expect_error(
      swap_vanity_urls(fails, works),
      paste(
        "Unable to modify the vanity URL for content_a:",
        "https://connect\\.example/__api__/v1/content/c3426b0b/vanity",
        "request failed with Client error: \\(403\\) Forbidden"
      )
    )
    expect_error(
      swap_vanity_urls(works, fails),
      paste(
        "Unable to modify the vanity URL for content_b:",
        "https://connect\\.example/__api__/v1/content/c3426b0b/vanity",
        "request failed with Client error: \\(403\\) Forbidden"
      )
    )
  })
})
