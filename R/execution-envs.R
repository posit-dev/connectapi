#' Execution Environment
#'
#' An R6 class representing an execution environment.
#'
#' @family R6 classes
#' @export
ExecutionEnv <- R6::R6Class(
  "ExecutionEnv",
  public = list(
    connect = NULL,
    data = NULL,

    initialize = function(connect, data) {
      validate_R6_class(connect, "Connect")
      self$connect <- connect
      self$data <- data
    },

    print = function(...) {
      cat("Execution Environment \n")
      cat(glue::glue('  Title: "{self$title}"\n', .trim = FALSE))
      cat(glue::glue('  Description: "{self$description}"\n', .trim = FALSE))
      cat(glue::glue('  Name: "{self$name}"\n', .trim = FALSE))
      cat("  Runtimes:\n")
      print(self$all_runtimes)
    }
  ),

  active = list(
    all_runtimes = function() {
      r <- purrr::map_df(.x = self$r$installations, .f = ~ .x)
      r$language <- "r"

      python <- purrr::map_df(.x = self$python$installations, .f = ~ .x)
      python$language <- "python"

      quarto <- purrr::map_df(.x = self$quarto$installations, .f = ~ .x)
      quarto$language <- "quarto"

      tensorflow <- purrr::map_df(.x = self$tensorflow$installations, .f = ~ .x)
      tensorflow$language <- "tensorflow"

      out <- rbind(r, python, quarto, tensorflow)
      out[c("language", setdiff(names(out), "language"))]
    }
  )
)

`[[.ExecutionEnv` <- function(x, name) {
  data <- get("data", envir = x)
  if (name %in% names(data)) {
    return(data[[name]])
  }
  get(name, envir = x)
}

`$.ExecutionEnv` <- function(x, name) {
  x[[name]]
}

get_execution_envs <- function(connect) {
  res <- connect$GET(v1_url("environments"))
  envs <- list()
  for (env in res) {
    envs <- append(envs, ExecutionEnv$new(client, env))
  }
  return(envs)
}
