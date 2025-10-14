# Tests for get_user_guid() helper function ----

test_that("get_user_guid() works with character GUID", {
  guid <- "20a79ce3-6e87-4522-9faf-be24228800a4"
  expect_equal(get_user_guid(guid), guid)
})

test_that("get_user_guid() works with connect_user object", {
  user <- structure(
    list(
      guid = "20a79ce3-6e87-4522-9faf-be24228800a4",
      username = "carlos12",
      first_name = "Carlos",
      last_name = "User"
    ),
    class = "connect_user"
  )
  expect_equal(get_user_guid(user), "20a79ce3-6e87-4522-9faf-be24228800a4")
})

test_that("get_user_guid() errors with invalid input", {
  expect_error(
    get_user_guid(123),
    "user must be either a character string \\(GUID\\) or a connect_user object"
  )
  expect_error(
    get_user_guid(list(name = "test")),
    "user must be either a character string \\(GUID\\) or a connect_user object"
  )
})

test_that("get_user_guid() errors when connect_user has no guid field", {
  user <- structure(
    list(username = "carlos12"),
    class = "connect_user"
  )
  expect_error(
    get_user_guid(user),
    "connect_user object does not contain a guid field"
  )
})

# Tests for Connect client methods accepting connect_user objects ----

with_mock_api({
  test_that("we can retrieve the users list", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    users <- get_users(con)
    expect_s3_class(users, "connect_users")
    expect_equal(length(users), 3)
  })

  test_that("we can retrieve a user by id", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    a_user <- con$user("20a79ce3-6e87-4522-9faf-be24228800a4")
    # There is no User class?
    expect_type(a_user, "list")
    expect_equal(a_user$first_name, "Carlos")
  })

  test_that("Connect$user() accepts connect_user object", {
    con <- Connect$new(server = "https://connect.example", api_key = "fake")
    user <- con$user("20a79ce3-6e87-4522-9faf-be24228800a4")
    same_user <- con$user(user)
    expect_equal(same_user$guid, "20a79ce3-6e87-4522-9faf-be24228800a4")
    expect_equal(same_user$first_name, "Carlos")
  })
})

without_internet({
  test_that("Querying users by prefix", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_GET(
      client$users(prefix = "TEST"),
      "https://connect.example/__api__/v1/users?page_number=1&page_size=500&prefix=TEST"
    )

    # Now with spaces
    expect_GET(
      client$users(prefix = "A User Name", page_size = 5),
      "https://connect.example/__api__/v1/users?page_number=1&page_size=5&prefix=A%20User%20Name"
    )

    # Now with too big page size: it automatically truncates (maybe that's bad)
    expect_GET(
      client$users(page_size = 1000),
      "https://connect.example/__api__/v1/users?page_number=1&page_size=500"
    )
  })

  test_that("Querying remote users", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    expect_GET(
      client$users_remote(prefix = "A user name"),
      "https://connect.example/__api__/v1/users/remote?prefix=A%20user%20name"
    )
  })

  test_that("users_lock() accepts connect_user object or GUID string", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    user_guid <- "20a79ce3-6e87-4522-9faf-be24228800a4"
    user <- structure(list(guid = user_guid), class = "connect_user")

    expect_POST(
      client$users_lock(user_guid),
      "https://connect.example/__api__/v1/users/20a79ce3-6e87-4522-9faf-be24228800a4/lock"
    )

    expect_POST(
      client$users_lock(user),
      "https://connect.example/__api__/v1/users/20a79ce3-6e87-4522-9faf-be24228800a4/lock"
    )
  })

  test_that("users_unlock() accepts connect_user object or GUID string", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    user_guid <- "20a79ce3-6e87-4522-9faf-be24228800a4"
    user <- structure(list(guid = user_guid), class = "connect_user")

    expect_POST(
      client$users_unlock(user_guid),
      "https://connect.example/__api__/v1/users/20a79ce3-6e87-4522-9faf-be24228800a4/lock"
    )

    expect_POST(
      client$users_unlock(user),
      "https://connect.example/__api__/v1/users/20a79ce3-6e87-4522-9faf-be24228800a4/lock"
    )
  })

  test_that("users_update() accepts connect_user object or GUID string", {
    client <- Connect$new(server = "https://connect.example", api_key = "fake")
    user_guid <- "20a79ce3-6e87-4522-9faf-be24228800a4"
    user <- structure(list(guid = user_guid), class = "connect_user")

    expect_PUT(
      client$users_update(user_guid, first_name = "New Name"),
      "https://connect.example/__api__/v1/users/20a79ce3-6e87-4522-9faf-be24228800a4"
    )

    expect_PUT(
      client$users_update(user, first_name = "New Name"),
      "https://connect.example/__api__/v1/users/20a79ce3-6e87-4522-9faf-be24228800a4"
    )
  })
})
