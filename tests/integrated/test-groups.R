user_guid <- NULL
group_guid <- NULL

test_that("groups_create works", {
  ss <- client$server_settings()
  if (ss$authentication$name %in% c("LDAP")) {
    skip("not implemented for this authentication provider")
  }
  groupname <- create_random_name()
  res <- client$groups_create(
    name = groupname
  )

  group_guid <<- res$guid

  expect_equal(res$name, groupname)
})

test_that("groups works", {
  groups <- client$groups()

  expect_gt(length(groups$results), 0)
})

test_that("group_member_add works", {
  user_guid <<- client$users_create(
    username = paste0("group_member", create_random_name()),
    email = "test@example.com",
    user_must_set_password = TRUE
  )$guid

  res <- client$group_member_add(group_guid, user_guid)

  members <- client$group_members(group_guid)

  expect_true(user_guid %in% purrr::map_chr(members$results, ~ .x$guid))
})

test_that("group_member_remove works", {
  res <- client$group_member_remove(group_guid, user_guid)

  members <- client$group_members(group_guid)

  expect_false(user_guid %in% purrr::map_chr(members$results, ~ .x$guid))
})
