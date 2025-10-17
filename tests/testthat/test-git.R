without_internet({
  scoped_experimental_silence()

  repo_path <- function(subpath) {
    glue::glue("https://connect.example/__api__/repo/{subpath}")
  }

  test_that("Query params to repo_account", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_GET(
      con$repo_account("https://github.com/posit-dev/connectapi"),
      repo_path("account?url=https%3A%2F%2Fgithub.com")
    )
    expect_error(
      con$repo_account("asdf"),
      "Scheme and hostname must be provided"
    )
  })

  test_that("Query params to repo_branches", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_GET(
      con$repo_branches("https://github.com/posit-dev/connectapi"),
      repo_path(
        "branches?url=https%3A%2F%2Fgithub.com%2Fposit-dev%2Fconnectapi"
      )
    )
  })

  test_that("Query params to repo_manifest_dirs", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_GET(
      con$repo_manifest_dirs("https://github.com/posit-dev/connectapi", "main"),
      repo_path(
        "manifest-dirs?url=https%3A%2F%2Fgithub.com%2Fposit-dev%2Fconnectapi&branch=main"
      )
    )
  })
})

with_mock_api({
  test_that("we can retrieve a repository information if it exists", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    item <- content_item(con, "f2f37341-e21d-3d80-c698-a935ad614066")
    expect_true(item$repository()$polling)
  })

  test_that("repository is null if it is not set", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    item <- content_item(con, "c3426b0b-e21d-3d80-c698-a935ad614066")
    expect_null(item$repository())
  })

  test_that("we can set a repository", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    item <- content_item(con, "c3426b0b-e21d-3d80-c698-a935ad614066")
    expect_PUT(
      item$repo_set(repository = "https://github.com/posit-dev/connectapi"),
      "https://connect.example/__api__/v1/content/c3426b0b/repository",
      '{"repository":"https://github.com/posit-dev/connectapi",',
      '"branch":"main","directory":".","polling":false}'
    )
  })

  test_that("we can enable polling", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    item <- content_item(con, "f2f37341-e21d-3d80-c698-a935ad614066")
    expect_PATCH(
      item$repo_enable(TRUE),
      "https://connect.example/__api__/v1/content/f2f37341-e21d-3d80-c698-a935ad614066/repository",
      '{"polling":true}'
    )
  })
})
