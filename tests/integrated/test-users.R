test_that("users_create works", {
  ss <- client$server_settings()
  if (ss$authentication$name %in% c("LDAP")) {
    skip("not implemented for this authentication provider")
  }
  username <- create_random_name()
  password <- uuid::UUIDgenerate(use.time = TRUE)
  res <- client$users_create(
    username = username,
    first_name = "Test",
    last_name = "User",
    user_role = "publisher",
    email = "test@example.com",
    password = password
  )

  expect_equal(res$username, username)
})

test_that("users works", {
  users <- client$users()

  expect_gt(length(users$results), 0)
})

test_that("user_guid_from_username works", {
  expect_error(
    user_guid_from_username(client, "this-user-prefix-does-not-exist"),
    "user not found"
  )

  user_username <- create_random_name(20)
  user_res <- client$users_create(
    user_username,
    "example@example.com",
    password = user_username
  )

  user_username_2 <- paste0(user_username, "X")
  user_res_2 <- client$users_create(
    user_username_2,
    "example@example.com",
    password = user_username_2
  )

  expect_warning(
    user_guid_from_username(client, substr(user_username, 0, 19)),
    "multiple users found"
  )

  expect_equal(
    user_guid_from_username(client, user_username),
    user_res$guid
  )
  expect_equal(
    user_guid_from_username(client, user_username_2),
    user_res_2$guid
  )
})
