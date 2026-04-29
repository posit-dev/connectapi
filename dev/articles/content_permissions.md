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

    ## Bundling directory (/tmp/RtmpVzb615/bundledir2a7e734e4ce8)

``` r
content_1 <- deploy(client, bnd, title = "App 1")
```

    ## Getting content endpoint

    ## Found EXISTING content 66db7739-45c1-4f2d-8cde-6102608c4004 with name mwlefoodfieexombwkkeulbfd on http://localhost:3939

    ## Uploading bundle

    ## Deploying bundle

``` r
content_2 <- deploy(client, bnd, title = "App 2")
```

    ## Getting content endpoint

    ## Found EXISTING content 187adfcf-9fcd-4739-952f-e8e8dc58bbe0 with name pbcyvkgufivjubqtxvafbsnay on http://localhost:3939

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
    ##   Content GUID: 66db7739-45c1-4f2d-8cde-6102608c4004
    ##   URL: http://localhost:3939/connect/#/apps/66db7739-45c1-4f2d-8cde-6102608c4004
    ##   Task ID: r9Vn5bqJ4JWnCq4J

``` r
set_content_tags(content_2, tag_1)
```

    ## Posit Connect Tag Tree (content)
    ## └── Example
    ##    └── Permissions

    ## Posit Connect Content Task: 
    ##   Content GUID: 187adfcf-9fcd-4739-952f-e8e8dc58bbe0
    ##   URL: http://localhost:3939/connect/#/apps/187adfcf-9fcd-4739-952f-e8e8dc58bbe0
    ##   Task ID: lqlTLeWNO5xU6Bmt

``` r
content_add_user(content_1, user_restricted$guid, role = "viewer")
```

    ## Adding permission for user '3a18b08a-4a16-4de3-8d36-261a87fd0458' with role 'viewer'

    ## Posit Connect Content Task: 
    ##   Content GUID: 66db7739-45c1-4f2d-8cde-6102608c4004
    ##   URL: http://localhost:3939/connect/#/apps/66db7739-45c1-4f2d-8cde-6102608c4004
    ##   Task ID: r9Vn5bqJ4JWnCq4J

``` r
content_add_user(content_1, user_all$guid, "viewer")
```

    ## Adding permission for user '469bc9ea-4e6b-4ede-83a9-90c022518e48' with role 'viewer'

    ## Posit Connect Content Task: 
    ##   Content GUID: 66db7739-45c1-4f2d-8cde-6102608c4004
    ##   URL: http://localhost:3939/connect/#/apps/66db7739-45c1-4f2d-8cde-6102608c4004
    ##   Task ID: r9Vn5bqJ4JWnCq4J

``` r
content_add_user(content_2, user_all$guid, "viewer")
```

    ## Adding permission for user '469bc9ea-4e6b-4ede-83a9-90c022518e48' with role 'viewer'

    ## Posit Connect Content Task: 
    ##   Content GUID: 187adfcf-9fcd-4739-952f-e8e8dc58bbe0
    ##   URL: http://localhost:3939/connect/#/apps/187adfcf-9fcd-4739-952f-e8e8dc58bbe0
    ##   Task ID: lqlTLeWNO5xU6Bmt

## Retrieve the Content List

The
[`content_list_with_permissions()`](https://posit-dev.github.io/connectapi/dev/reference/content_list_with_permissions.md)
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
    ## 1 3     187adfcf-9fcd-4739-952f-e8e8dc58bbe0 469bc9ea-4e6b… user           view…
    ## 2 NA    187adfcf-9fcd-4739-952f-e8e8dc58bbe0 8278beaf-f117… user           owner
    ## 
    ## [[2]]
    ## # A tibble: 3 × 5
    ##   id    content_guid                         principal_guid principal_type role 
    ##   <chr> <chr>                                <chr>          <chr>          <chr>
    ## 1 1     66db7739-45c1-4f2d-8cde-6102608c4004 3a18b08a-4a16… user           view…
    ## 2 2     66db7739-45c1-4f2d-8cde-6102608c4004 469bc9ea-4e6b… user           view…
    ## 3 NA    66db7739-45c1-4f2d-8cde-6102608c4004 8278beaf-f117… user           owner

## Filter the Content List

We added a helper function to the package that should filter the content
list for you:
[`content_list_guid_has_access()`](https://posit-dev.github.io/connectapi/dev/reference/content_list_with_permissions.md)

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
