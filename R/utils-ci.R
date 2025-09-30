# nocov start

version_to_docker_tag <- function(version) {
  # Prior to 2022.09.0, the plain version number was the tag
  # After, it's "<ubuntu-codename>-<version>"
  # If you want a specific image tag, just pass it in and it will go through unchanged
  try(
    {
      numver <- numeric_version(version)
      if (numver > "2023.06") {
        version <- paste0("jammy-", version)
      } else if (numver >= "2022.09") {
        # There's both jammy and bionic for these, but the bionic ones
        # seem more reliable in CI
        version <- paste0("bionic-", version)
      }
    },
    silent = TRUE
  )
  version
}

compose_start <- function(
  connect_license_path,
  connect_version,
  clean = TRUE
) {
  warn_dire("compose_start")
  scoped_dire_silence()

  stopifnot(fs::file_exists(connect_license_path))
  connect_license_path <- fs::path_abs(connect_license_path)

  compose_file_path <- system.file(
    "ci/test-connect-lic.yml",
    package = "connectapi"
  )

  env_vars <- c(
    CONNECT_VERSION = version_to_docker_tag(connect_version),
    PATH = Sys.getenv("PATH"),
    RSC_LICENSE_FILE = connect_license_path
  )
  # system2 needs a character vector of name=value
  env_vars <- paste(names(env_vars), env_vars, sep = "=")
  docker <- Sys.which("docker")

  # stop compose
  if (clean) {
    system2(
      docker,
      c("compose", "-f", compose_file_path, "down"),
      env = env_vars
    )
  }

  # start compose
  cat_line("docker compose: starting...")
  args <- c("compose", "-f", compose_file_path, "up", "-d")
  # do not show env_vars b/c need to handle license securely
  cat_line(glue::glue("command: {docker} {paste(args, collapse=' ')}"))
  system2(docker, args, env = env_vars)
  cat_line("docker compose: started!")
  invisible()
}

compose_find_hosts <- function(prefix) {
  warn_dire("compose_find")
  scoped_dire_silence()

  # get docker containers
  cat_line("docker: getting list of containers...")
  docker_ps_output <- system2("docker", "ps", stdout = TRUE)
  cat(docker_ps_output, sep = "\n")

  containers <- grep(prefix, docker_ps_output, value = TRUE)
  ports <- sub(".*0\\.0\\.0\\.0:([0-9]+)->3939.*", "\\1", containers)
  cat_line(glue::glue("docker: got ports {ports[1]} and {ports[2]}"))

  paste0("http://localhost:", ports)
}


update_renviron_creds <- function(
  server,
  api_key,
  prefix,
  .file = ".Renviron"
) {
  cat_line(glue::glue("connect: writing values for {prefix} to {.file}"))
  curr_environ <- tryCatch(readLines(.file), error = function(e) {
    print(e)
    return(character())
  })

  curr_environ <- curr_environ[
    !grepl(glue::glue("^{prefix}_SERVER="), curr_environ)
  ]
  curr_environ <- curr_environ[
    !grepl(glue::glue("^{prefix}_API_KEY="), curr_environ)
  ]
  output_environ <- glue::glue(
    paste(curr_environ, collapse = "\n"),
    "{prefix}_SERVER={server}",
    "{prefix}_API_KEY={api_key}",
    .sep = "\n"
  )
  if (!fs::file_exists(.file)) {
    fs::file_touch(.file)
  }
  writeLines(output_environ, .file)
  invisible()
}

build_test_env <- function(
  connect_license_path,
  clean = TRUE,
  username = "admin",
  password = "admin0",
  connect_version = Sys.getenv("CONNECT_VERSION", current_connect_version)
) {
  warn_dire("build_test_env")
  scoped_dire_silence()

  compose_start(
    connect_license_path = connect_license_path,
    clean = clean,
    connect_version = connect_version
  )

  # It was ci_connect before but it's ci-connect on my machine now;
  # this is a regex so it will match either
  hosts <- compose_find_hosts(prefix = "ci.connect")

  wait_for_connect_ready <- function(host, container_name, timeout = 120) {
    client <- HackyConnect$new(server = host, api_key = NULL)
    start_time <- Sys.time()
    last_msg <- start_time
    ping_url <- client$server_url("__ping__")

    while (
      as.numeric(difftime(Sys.time(), start_time, units = "secs")) < timeout
    ) {
      ok <- try(
        {
          res <- client$GET(url = client$server_url("__ping__"), parser = NULL)
          httr::status_code(res) == 200
        },
        silent = TRUE
      )
      if (isTRUE(ok)) {
        return(invisible(TRUE))
      }
      if (difftime(Sys.time(), last_msg, units = "secs") >= 5) {
        cat_line(glue::glue("waiting for {ping_url} ..."))
        last_msg <- Sys.time()
      }
      Sys.sleep(1)
    }

    # Before failing, capture diagnostics
    cat_line("Connect did not become ready in time. Capturing diagnostics...")
    cat_line(glue::glue("=== Docker logs for {container_name} ==="))
    try(
    {
      logs <- system2(
        "docker",
        c("logs", "--tail", "100", container_name),
        stdout = TRUE,
        stderr = TRUE
      )
      cat(logs, sep = "\n")
    },
    silent = TRUE
    )

    cat_line(glue::glue("=== Docker inspect for {container_name} ==="))
    try(
    {
      inspect <- system2(
        "docker",
        c("inspect", container_name),
        stdout = TRUE,
        stderr = TRUE
      )
      cat(inspect, sep = "\n")
    },
    silent = TRUE
    )


    stop("Connect did not become ready in time: ", ping_url)
  }

  wait_for_connect_ready(hosts[1], container_name = "ci-connect-1")
  wait_for_connect_ready(hosts[2], container_name = "ci-connect-2")

  cat_line("connect: creating first admin...")
  a1 <- create_first_admin(
    hosts[1],
    "admin",
    "admin0",
    "admin@example.com"
  )
  a2 <- create_first_admin(
    hosts[2],
    "admin",
    "admin0",
    "admin@example.com"
  )

  update_renviron_creds(a1$server, a1$api_key, "TEST_1")
  update_renviron_creds(a2$server, a2$api_key, "TEST_2")

  cat_line("connect: done")

  cat_line()
  cat_line()
  cat_line("NOTE: be sure to reload .Renviron before running tests!")
  cat_line('  readRenviron(".Renviron")')
  cat_line('  source("tests/test-integrated.R")')
  cat_line()
  cat_line()

  return(
    list(
      connect1 = a1,
      connect2 = a2
    )
  )
}

create_first_admin <- function(url, user, password, email) {
  warn_dire("create_first_admin")
  check_connect_license(url)

  # Use HackyConnect to create the user and log in with password,
  # then create an API key.
  client <- HackyConnect$new(server = url, api_key = NULL)

  new_user_payload <- list(
    username = user,
    password = password,
    email = email
  )
  tryCatch(
    new_user <- client$POST(path = v1_url("users"), body = new_user_payload),
    error = function(e) {
      message(glue::glue("Error creating first admin: {e}"))
    }
  )

  client$login(user = user, password = password)

  api_key <- tryCatch(
    client$POST(
      path = v1_url("users", new_user[["guid"]], "keys"),
      body = list(name = "first-key")
    ),
    error = function(e) {
      client$POST(
        unversioned_fallback_url("keys"),
        body = list(name = "first-key")
      )
    }
  )

  # Then we return a non-hacky Connect object with the API key
  connect(url, api_key$key)
}

HackyConnect <- R6::R6Class(
  "HackyConnect",
  inherit = Connect,
  public = list(
    xsrf = NULL,
    login = function(user, password) {
      warn_dire("HackyConnect")
      res <- httr::POST(
        glue::glue("{self$server}/__login__"),
        body = list(username = user, password = password),
        encode = "json"
      )

      res_cookies <- httr::cookies(res)
      self$xsrf <- res_cookies[res_cookies$name == "RSC-XSRF", "value"]

      httr::content(res, as = "parsed")
    },
    add_auth = function() {
      httr::add_headers("X-RSC-XSRF" = self$xsrf)
    }
  )
)

# nocov end
