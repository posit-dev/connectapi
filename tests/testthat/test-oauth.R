with_mock_api({
  test_that("we can retrieve the oauth user credentials", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_true(validate_R6_class(client, "Connect"))
    credentials <- get_oauth_credentials(
      client,
      user_session_token = "user-session-token"
    )
    expect_equal(
      credentials,
      list(
        access_token = "user-access-token",
        issued_token_type = "urn:ietf:params:oauth:token-type:access_token",
        token_type = "Bearer"
      )
    )
  })

  test_that("we can retrieve the oauth content credentials with an explicit token", {
    withr::local_options(list(rlib_warning_verbosity = "verbose"))

    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_true(validate_R6_class(client, "Connect"))
    expect_warning(
      credentials <- get_oauth_content_credentials(
        client,
        content_session_token = "content-session-token"
      )
    )
    expect_equal(
      credentials,
      list(
        access_token = "content-access-token",
        issued_token_type = "urn:ietf:params:oauth:token-type:access_token",
        token_type = "Bearer"
      )
    )
  })

  test_that("we can retrieve the oauth content credentials with an env var", {
    withr::local_options(list(rlib_warning_verbosity = "verbose"))
    withr::local_envvar(
      list(CONNECT_CONTENT_SESSION_TOKEN = "content-session-token")
    )

    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_true(validate_R6_class(client, "Connect"))
    expect_warning(
      credentials <- get_oauth_content_credentials(client)
    )
    expect_equal(
      credentials,
      list(
        access_token = "content-access-token",
        issued_token_type = "urn:ietf:params:oauth:token-type:access_token",
        token_type = "Bearer"
      )
    )
  })

  test_that("we cannot retrieve the oauth content credentials without a token or env var", {
    withr::local_options(list(rlib_warning_verbosity = "verbose"))

    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_true(validate_R6_class(client, "Connect"))
    expect_error(
      expect_warning(get_oauth_content_credentials(client)),
      "Could not find the CONNECT_CONTENT_SESSION_TOKEN environment variable."
    )
  })

  test_that("we can retrieve the AWS viewer credentials", {
    withr::local_options(list(rlib_warning_verbosity = "verbose"))

    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_true(validate_R6_class(client, "Connect"))
    expect_warning(
      credentials <- get_aws_credentials(
        client,
        user_session_token = "user-session-token"
      )
    )
    expect_equal(
      credentials,
      list(
        access_key_id = "abc123",
        secret_access_key = "def456",
        session_token = "ghi789",
        expiration = "2025-01-01T00:00:00Z"
      )
    )
  })

  test_that("we can retrieve the AWS content credentials with an explicit token", {
    # get_aws_content_credentials produces multiple warnings about the Posit
    # Connect version; suppress these
    withr::local_options(list(rlib_warning_verbosity = "quiet"))

    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_true(validate_R6_class(client, "Connect"))

    credentials <- get_aws_content_credentials(
      client,
      content_session_token = "content-session-token"
    )

    expect_equal(
      credentials,
      list(
        access_key_id = "abc123",
        secret_access_key = "def456",
        session_token = "ghi789",
        expiration = "2025-01-01T00:00:00Z"
      )
    )
  })

  test_that("we can retrieve the AWS content credentials with an env var", {
    withr::local_options(list(rlib_warning_verbosity = "quiet"))
    withr::local_envvar(
      list(CONNECT_CONTENT_SESSION_TOKEN = "content-session-token")
    )

    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_true(validate_R6_class(client, "Connect"))


    credentials <- get_aws_content_credentials(client)

    expect_equal(
      credentials,
      list(
        access_key_id = "abc123",
        secret_access_key = "def456",
        session_token = "ghi789",
        expiration = "2025-01-01T00:00:00Z"
      )
    )
  })

  test_that("we cannot retrieve the AWS content credentials without a token or env var", {
    withr::local_options(list(rlib_warning_verbosity = "quiet"))

    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_true(validate_R6_class(client, "Connect"))
    expect_error(
      get_aws_content_credentials(client),
      "Could not find the CONNECT_CONTENT_SESSION_TOKEN environment variable."
    )
  })
})
