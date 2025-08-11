structure(
  list(
    url = "__api__/v1/oauth/integrations",
    status_code = 400L,
    headers = structure(
      list(`content-type` = "application/json"),
      class = c("insensitive", "list")
    ),
    content = charToRaw(
      "{\"code\":228,\"error\":\"The config key max_role must be one of (Viewer, Publisher, Admin)\",\"payload\":null}"
    )
  ),
  class = "response"
)
