# Content Permissions

## Getting Started

To filter content by permissions, you first need a “baseline set of
content.” This could be all content on the server, all content in a
particular tag, etc.

> NOTE: performance will depend heavily on the size of this baseline set
> of content, because the permissions API today requires enumeration. To
> improve performance for large sets of content, you can use `pins` or
> caching on disk to reduce how often the requests must be re-executed.

We will start by deploying a few pieces of test content, two test users,
set access controls, and tags:

``` r
bnd <- bundle_static(system.file("logo.png", package = "connectapi"))
```

    ## Bundling directory (/tmp/RtmpHV2J4I/bundledir2b9f3aef3f28)

``` r
content_1 <- deploy(client, bnd, title = "App 1")
```

    ## Getting content endpoint

    ## Found EXISTING content 4466417c-18e6-4429-ad2b-d6766bbf9ace with name mwlefoodfieexombwkkeulbfd on http://localhost:3939

    ## Uploading bundle

    ## Deploying bundle

``` r
content_2 <- deploy(client, bnd, title = "App 2")
```

    ## Getting content endpoint

    ## Found EXISTING content 6457cf39-c5f7-4f2c-beab-b97f03168578 with name pbcyvkgufivjubqtxvafbsnay on http://localhost:3939

    ## Uploading bundle

    ## Deploying bundle

``` r
user_restricted <- client$users_create("example_restricted", "restricted@example.com", password = create_random_name())
user_all <- client$users_create("example_all", "all@example.com", password = create_random_name())

invisible(create_tag_tree(client, "Example", "Permissions"))
```

    ## Posit Connect Tag Tree (filtered)
    ## └── Example
    ##    └── Permissions

``` r
tags <- get_tags(client)
tag_1 <- tags$Example$Permissions

set_content_tags(content_1, tag_1)
```

    ## Posit Connect Tag Tree (content)
    ## └── Example
    ##    └── Permissions

    ## Posit Connect Content Task: 
    ##   Content GUID: 4466417c-18e6-4429-ad2b-d6766bbf9ace
    ##   URL: http://localhost:3939/connect/#/apps/4466417c-18e6-4429-ad2b-d6766bbf9ace
    ##   Task ID: Hz5iNXSz8wZN9Ttc

``` r
set_content_tags(content_2, tag_1)
```

    ## Posit Connect Tag Tree (content)
    ## └── Example
    ##    └── Permissions

    ## Posit Connect Content Task: 
    ##   Content GUID: 6457cf39-c5f7-4f2c-beab-b97f03168578
    ##   URL: http://localhost:3939/connect/#/apps/6457cf39-c5f7-4f2c-beab-b97f03168578
    ##   Task ID: ub2ytIuKgWf39MT1

``` r
content_add_user(content_1, user_restricted$guid, role = "viewer")
```

    ## Adding permission for user '0eb8216a-c1ed-4b73-a205-7fa9a4a7841b' with role 'viewer'

    ## Posit Connect Content Task: 
    ##   Content GUID: 4466417c-18e6-4429-ad2b-d6766bbf9ace
    ##   URL: http://localhost:3939/connect/#/apps/4466417c-18e6-4429-ad2b-d6766bbf9ace
    ##   Task ID: Hz5iNXSz8wZN9Ttc

``` r
content_add_user(content_1, user_all$guid, "viewer")
```

    ## Adding permission for user '21cee2e7-65a0-4ad1-b5d6-ee8aa61d713f' with role 'viewer'

    ## Posit Connect Content Task: 
    ##   Content GUID: 4466417c-18e6-4429-ad2b-d6766bbf9ace
    ##   URL: http://localhost:3939/connect/#/apps/4466417c-18e6-4429-ad2b-d6766bbf9ace
    ##   Task ID: Hz5iNXSz8wZN9Ttc

``` r
content_add_user(content_2, user_all$guid, "viewer")
```

    ## Adding permission for user '21cee2e7-65a0-4ad1-b5d6-ee8aa61d713f' with role 'viewer'

    ## Posit Connect Content Task: 
    ##   Content GUID: 6457cf39-c5f7-4f2c-beab-b97f03168578
    ##   URL: http://localhost:3939/connect/#/apps/6457cf39-c5f7-4f2c-beab-b97f03168578
    ##   Task ID: ub2ytIuKgWf39MT1

## Retrieve the Content List

The
[`content_list_with_permissions()`](https://posit-dev.github.io/connectapi/reference/content_list_with_permissions.md)
function is the core of what we want. However, it defaults to return
*all content on the server.* For some servers, this is very expensive
(and can take 30 minutes or more).

Instead, we recommend using the `.p` argument to define a “predicate”
function (in the style of
[`purrr::keep()`](https://purrr.tidyverse.org/reference/keep.html)) that
determines which records to keep. Since all this predicate has access to
is the “content list” itself, we will retrieve a list of Content GUIDs
first.

``` r
my_tag_content <- content_list_by_tag(client, tag_1)
content_guids <- my_tag_content$guid

c_with_p <- content_list_with_permissions(client, .p = ~ .x$guid %in% content_guids)
```

    ## Getting content list

    ## Getting permission list

``` r
# another approach, with a function
c_with_p <- content_list_with_permissions(client, .p = function(.x) {
  .x$guid %in% content_guids
})
```

    ## Getting content list
    ## Getting permission list

``` r
# notice the "permission" column:
c_with_p$permission
```

    ## [[1]]
    ## # A tibble: 2 × 5
    ##   id    content_guid                         principal_guid principal_type role 
    ##   <chr> <chr>                                <chr>          <chr>          <chr>
    ## 1 3     6457cf39-c5f7-4f2c-beab-b97f03168578 21cee2e7-65a0… user           view…
    ## 2 NA    6457cf39-c5f7-4f2c-beab-b97f03168578 e3b7a4f2-174d… user           owner
    ## 
    ## [[2]]
    ## # A tibble: 3 × 5
    ##   id    content_guid                         principal_guid principal_type role 
    ##   <chr> <chr>                                <chr>          <chr>          <chr>
    ## 1 1     4466417c-18e6-4429-ad2b-d6766bbf9ace 0eb8216a-c1ed… user           view…
    ## 2 2     4466417c-18e6-4429-ad2b-d6766bbf9ace 21cee2e7-65a0… user           view…
    ## 3 NA    4466417c-18e6-4429-ad2b-d6766bbf9ace e3b7a4f2-174d… user           owner

## Filter the Content List

We added a helper function to the package that should filter the content
list for you:
[`content_list_guid_has_access()`](https://posit-dev.github.io/connectapi/reference/content_list_with_permissions.md)

In a Shiny application or other personalized context (i.e. using
`session$user`), you then filter the content list to only what a user
should see (using the `permissions` column returned above)

``` r
# restricted has access
content_list_guid_has_access(c_with_p, user_restricted$guid) %>% .$title
```

    ## [1] "mwlefoodfieexombwkkeulbfd"

``` r
# "all" has access
content_list_guid_has_access(c_with_p, user_all$guid) %>% .$title
```

    ## [1] "pbcyvkgufivjubqtxvafbsnay" "mwlefoodfieexombwkkeulbfd"

## Display the Content List

We plan to build a full example in Shiny (and to show example code
below). However, suffice it to say that for RStudio Connect version
1.9.0 or newer,
[`connectwidgets`](https://pkgs.rstudio.com/connectwidgets/) is a great
way to plan to display your data, and provides several helpers for doing
so!
