#' Paging
#'
#' Helper functions that make paging easier in
#' the Posit Connect Server API.
#'
#' @rdname paging
#'
#' @param client A Connect client object
#' @param req For page_cursor, the output from an initial response to an API
#'   endpoint that uses cursor-based pagination. For page_offset, a request that
#'   needs to be paged.
#' @param limit A row limit
#'
#' @return The aggregated results from all requests
#'
#' @export
page_cursor <- function(client, req, limit = Inf) {
  prg <- optional_progress_bar(
    format = "downloading page :current (:tick_rate/sec) :elapsedfull",
    total = NA,
    clear = FALSE
  )

  prg$tick()
  response <- req

  res <- growable_list()
  gl_add(res, response$results)
  while (!is.null(response$paging$`next`) && gl_length(res) < limit) {
    prg$tick()

    next_url <- response$paging$`next`
    response <- client$GET(url = next_url)

    gl_add(res, response$results)
  }

  head(gl_as_list(res), n = limit)
}
# TODO: Decide if this `limit = Inf` is helpful or a hack...
#       it is essentially a "row limit" on paging

#' @rdname paging
#' @export
page_offset <- function(client, req, limit = Inf) {
  qreq <- rlang::enquo(req)
  qexpr <- rlang::quo_get_expr(qreq)

  prg <- optional_progress_bar(
    format = "downloading page :current (:tick_rate/sec) :elapsedfull",
    total = NA,
    clear = FALSE
  )

  # handle paging
  prg$tick()

  req_response <- rlang::eval_tidy(qreq)
  res <- req_response$results
  total_items <- req_response$total

  agg_response <- res
  agg_length <- length(agg_response)
  while (length(res) > 0 && agg_length < limit && agg_length < total_items) {
    prg$tick()

    # bump the page number
    current_page <- req_response$current_page
    new_expr <- qexpr
    new_expr$page_number <- current_page + 1
    new_req <- rlang::quo_set_expr(qreq, new_expr)

    # next request
    req_response <- rlang::eval_tidy(new_req)
    res <- req_response$results

    agg_response <- c(agg_response, res)
    agg_length <- length(agg_response)

    # clear out variables
    current_page <- NULL
    new_expr <- NULL
    new_req <- NULL
  }
  # Make sure we never return more than `limit` records
  head(agg_response, limit)
}

# Pre-allocated list that doubles in capacity as needed, to avoid copying on
# every request.
growable_list <- function(initial_size = 100L) {
  gl <- new.env(parent = emptyenv())
  gl$buf <- vector("list", initial_size)
  gl$n <- 0L
  gl
}

# Add items to a pre-allocated list. If the items would exceed the size of the
# list, increase the list size to double the existing one OR large enough to
# accommodate all the new items (whichever is larger).
gl_add <- function(gl, items) {
  n_new <- length(items)
  if (n_new == 0L) {
    return(invisible(gl))
  }
  # grow list if we've run out of space
  if (gl$n + n_new > length(gl$buf)) {
    new_size <- max(length(gl$buf) * 2L, gl$n + n_new)
    gl$buf[new_size] <- list(NULL)
  }
  gl$buf[seq.int(gl$n + 1L, gl$n + n_new)] <- items
  gl$n <- gl$n + n_new
  invisible(gl)
}

gl_length <- function(gl) {
  gl$n
}

gl_as_list <- function(gl) {
  gl$buf[seq_len(gl$n)]
}

optional_progress_bar <- function(...) {
  if (requireNamespace("progress", quietly = TRUE)) {
    progress::progress_bar$new(...)
  } else {
    # Return a mock object that behaves enough like a progress bar object
    list(
      tick = function() {}
    )
  }
}
