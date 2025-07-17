test_that("bundle_dir errors if no manifest.json", {
  expect_error(
    suppressMessages(bundle_dir(rprojroot::find_testthat_root_file(
      "bundle_dir_tests",
      "no_manifest"
    ))),
    "no `manifest.json`"
  )
})

test_that("bundle_dir warns if packrat.lock", {
  expect_warning(
    suppressMessages(bundle_dir(rprojroot::find_testthat_root_file(
      "bundle_dir_tests",
      "include_packrat_lock"
    ))),
    "`packrat.lock` file found"
  )
})

test_that("bundle_dir warns if packrat folder", {
  expect_warning(
    suppressMessages(bundle_dir(rprojroot::find_testthat_root_file(
      "bundle_dir_tests",
      "include_packrat"
    ))),
    "`packrat` directory found"
  )
})

test_that("bundle_dir not fooled by subfolders", {
  expect_error(
    suppressMessages(bundle_dir(rprojroot::find_testthat_root_file(
      "bundle_dir_tests",
      "subfolders"
    ))),
    "no `manifest.json`"
  )
})

test_that("bundle_dir works with relative paths", {
  bnd <- suppressMessages(bundle_dir(fs::path_rel(rprojroot::find_testthat_root_file(
    "bundle_dir_tests",
    "doc"
  ))))
  expect_true(fs::file_exists(bnd$path))
})

test_that("bundle_dir errors for nonexistent paths", {
  expect_error(
    suppressMessages(
      bundle_dir(rprojroot::find_testthat_root_file(
        "bundle_dir_tests",
        "does_not_exist_not_real"
      ))
    ),
    "not TRUE"
  )
})
