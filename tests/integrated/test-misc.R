test_that("audit_logs work", {
  logs <- client$audit_logs()
  expect_gt(length(logs$results), 0)

  logs2 <- client$audit_logs(nxt = logs$paging$cursors$`next`)
  expect_gt(length(logs2$results), 0)
})

test_that("server_settings work", {
  ss <- client$server_settings()

  expect_gt(length(ss), 0)
})

test_that("server_settings_r work", {
  ssr <- client$server_settings_r()

  expect_gt(length(ssr$installations), 0)
})
