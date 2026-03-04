connectapi_datetime_cols <- list(
  users = c("created_time", "updated_time", "active_time"),
  groups = character(),
  usage_shiny = c("started", "ended"),
  usage_static = c("time"),
  usage = c("timestamp"),
  content = c("created_time", "last_deployed_time"),
  audit_logs = c("time"),
  procs = character(),
  variant = c("created_time", "render_time"),
  rendering = c("render_time"),
  jobs = c("start_time", "end_time", "last_heartbeat_time", "queued_time"),
  bundles = c("created_time"),
  permissions = character(),
  group_content = character(),
  job_termination = character(),
  vanities = c("created_time"),
  job_log = c("timestamp"),
  packages = character(),
  content_packages = character(),
  integrations = c("created_time", "updated_time")
)

# Column names used by the lazy tibble system (tbl_connect) to report
# dim() / colnames() before data is fetched.
connectapi_lazy_cols <- list(
  users = c(
    "email", "username", "first_name", "last_name", "user_role",
    "created_time", "updated_time", "active_time", "confirmed", "locked",
    "external_id", "guid"
  ),
  groups = c("guid", "name", "owner_guid", "gid"),
  content = c(
    "guid", "name", "title", "description", "access_type",
    "connection_timeout", "read_timeout", "init_timeout", "idle_timeout",
    "max_processes", "min_processes", "max_conns_per_process", "load_factor",
    "created_time", "last_deployed_time", "bundle_id", "app_mode",
    "content_category", "parameterized", "cluster_name", "image_name",
    "r_version", "py_version", "quarto_version", "run_as",
    "run_as_current_user", "owner_guid", "content_url", "dashboard_url",
    "app_role", "vanity_url", "id", "owner", "tags"
  ),
  usage_shiny = c(
    "content_guid", "user_guid", "started", "ended", "data_version"
  ),
  usage_static = c(
    "content_guid", "user_guid", "variant_key", "time",
    "rendering_id", "bundle_id", "data_version"
  ),
  audit_logs = c(
    "id", "time", "user_id", "user_guid", "user_description",
    "action", "event_description"
  )
)
