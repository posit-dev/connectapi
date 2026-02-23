# connectapi Tags

## Getting Started

To understand how tags work with `connectapi`, you must first understand
tags in RStudio Connect.

- Tags in RStudio Connect consist of multiple “tag trees,” each with a
  “Category” as its parent.
- The tag hierarchy / structure is created by administrators
- Publishers and administrators can associate any non-Category tag with
  content
- A tag being a member of a “child” tag doe *not* automatically make it
  a member of the “parent” tag

As always, get started by defining the `CONNECT_SERVER` and
`CONNECT_API_KEY` variables, then initialize an API client.

``` r
library(connectapi)
client <- connect()
```

**NOTE:** This example report will create a few tag hierarchies and then
use them. As a result, to use this example verbatim requires admin
privileges and *will* create tags on your server.

## Create the Tag Tree(s)

To get started, we will create a tag tree to show how things work. The
[`create_tag()`](https://posit-dev.github.io/connectapi/dev/reference/tags.md)
helper allows you to create a singular tag (by specifying its parent,
etc.). For our purposes,
[`create_tag_tree()`](https://posit-dev.github.io/connectapi/dev/reference/tags.md)
is easier, since it creates the entire tree specified at once.

``` r
start_tags <- get_tags(client)
start_tags
```

    ## Posit Connect Tag Tree
    ##   < No tags >

``` r
tree_project_1 <- create_tag_tree(client, "DemoProject", "project_1")
```

    ## Posit Connect Tag Tree (filtered)
    ## └── DemoProject
    ##    └── project_1

``` r
tree_project_1
```

    ## Posit Connect API Client: 
    ##   Posit Connect Server: http://localhost:3939
    ##   Posit Connect API Key: ***********cvkN

``` r
tmp_tags <- get_tags(client)

tree_project_2 <- create_tag(client, name = "project_2", parent = tmp_tags$DemoProject)
```

    ## Posit Connect Tag Tree (filtered)
    ## └── DemoProject
    ##    └── project_2

``` r
tree_project_2
```

    ## Posit Connect API Client: 
    ##   Posit Connect Server: http://localhost:3939
    ##   Posit Connect API Key: ***********cvkN

``` r
tree_audience_1 <- create_tag_tree(client, "DemoAudience", "Sales")
```

    ## Posit Connect Tag Tree (filtered)
    ## └── DemoAudience
    ##    └── Sales

``` r
tree_audience_2 <- create_tag_tree(client, "DemoAudience", "Finance")
```

    ## Posit Connect Tag Tree (filtered)
    ## └── DemoAudience
    ##    └── Finance

``` r
get_tags(client)
```

    ## Posit Connect Tag Tree
    ## ├── DemoProject
    ## │   ├── project_1
    ## │   └── project_2
    ## └── DemoAudience
    ##    ├── Sales
    ##    └── Finance

## Content tags

In order to show how tags work, we need some content to work with.

``` r
bnd <- bundle_static(system.file("logo.png", package = "connectapi"))
```

    ## Bundling directory (/tmp/Rtmpg2JHv0/bundledir2aa066c5ccba)

``` r
content_1 <- deploy(client, bnd)
```

    ## Getting content endpoint

    ## 

    ## Uploading bundle

    ## Deploying bundle

``` r
content_2 <- deploy(client, bnd)
```

    ## Getting content endpoint

    ## 

    ## Uploading bundle

    ## Deploying bundle

### Set Tags

Content 1 is for `project_1` and `Sales`, so let’s set the tags! There
are a few ways to do so.

``` r
all_tags <- get_tags(client)

set_content_tag_tree(content_1, "DemoProject", "project_1")
```

    ## Posit Connect Tag Tree (content)
    ## └── DemoProject
    ##    └── project_1

    ## Posit Connect Content Task: 
    ##   Content GUID: 8308f952-62ed-42d4-8b29-3dd0abfde472
    ##   URL: http://localhost:3939/connect/#/apps/8308f952-62ed-42d4-8b29-3dd0abfde472
    ##   Task ID: lbA2bmkDpVgIn4Nx

``` r
set_content_tags(content_1, all_tags$DemoAudience$Sales)
```

    ## Posit Connect Tag Tree (content)
    ## ├── DemoProject
    ## │   └── project_1
    ## └── DemoAudience
    ##    └── Sales

    ## Posit Connect Content Task: 
    ##   Content GUID: 8308f952-62ed-42d4-8b29-3dd0abfde472
    ##   URL: http://localhost:3939/connect/#/apps/8308f952-62ed-42d4-8b29-3dd0abfde472
    ##   Task ID: lbA2bmkDpVgIn4Nx

Content 2 is for `project_2` and both Audiences (`Sales` and `Finance`).

``` r
set_content_tags(
  content_2,
  all_tags$DemoProject$project_2,
  all_tags$DemoAudience$Sales,
  all_tags$DemoAudience$Finance
)
```

    ## Posit Connect Tag Tree (content)
    ## ├── DemoProject
    ## │   └── project_2
    ## └── DemoAudience
    ##    ├── Sales
    ##    └── Finance

    ## Posit Connect Content Task: 
    ##   Content GUID: e8f30604-8902-486d-865f-959398523922
    ##   URL: http://localhost:3939/connect/#/apps/e8f30604-8902-486d-865f-959398523922
    ##   Task ID: TTRnn5omrOkpkAa5

### See the tags associated with content

In order to see the tags associated with content, use
[`get_content_tags()`](https://posit-dev.github.io/connectapi/dev/reference/tags.md).
The data structure is the same as
[`get_tags()`](https://posit-dev.github.io/connectapi/dev/reference/tags.md),
but the “whole list” is filtered to only the tags that are associated
with a piece of content.

``` r
c1_tags <- get_content_tags(content_1)
c1_tags
```

    ## Posit Connect Tag Tree (content)
    ## ├── DemoProject
    ## │   └── project_1
    ## └── DemoAudience
    ##    └── Sales

``` r
c2_tags <- get_content_tags(content_2)
c2_tags
```

    ## Posit Connect Tag Tree (content)
    ## ├── DemoProject
    ## │   └── project_2
    ## └── DemoAudience
    ##    ├── Sales
    ##    └── Finance

## List all content associated with a tag

Once tags have been defined, you can also search for all of the content
associated with a tag.

``` r
content_list_by_tag(client, all_tags$DemoAudience$Sales)
```

    ## # A tibble: 2 × 51
    ##   guid                 name  title description access_type locked locked_message
    ##   <chr>                <chr> <chr> <chr>       <chr>       <lgl>  <chr>         
    ## 1 e8f30604-8902-486d-… pbcy… pbcy… ""          acl         FALSE  ""            
    ## 2 8308f952-62ed-42d4-… mwle… mwle… ""          acl         FALSE  ""            
    ## # ℹ 44 more variables: connection_timeout <int>, read_timeout <int>,
    ## #   init_timeout <int>, idle_timeout <int>, max_processes <int>,
    ## #   min_processes <int>, max_conns_per_process <int>, load_factor <dbl>,
    ## #   memory_request <lgl>, memory_limit <lgl>, cpu_request <lgl>,
    ## #   cpu_limit <lgl>, amd_gpu_limit <lgl>, nvidia_gpu_limit <lgl>,
    ## #   service_account_name <lgl>, default_image_name <lgl>,
    ## #   default_environment_guid <lgl>, created_time <dttm>, …

``` r
content_list_by_tag(client, all_tags$DemoProject$project_1)
```

    ## # A tibble: 1 × 51
    ##   guid                 name  title description access_type locked locked_message
    ##   <chr>                <chr> <chr> <chr>       <chr>       <lgl>  <chr>         
    ## 1 8308f952-62ed-42d4-… mwle… mwle… ""          acl         FALSE  ""            
    ## # ℹ 44 more variables: connection_timeout <int>, read_timeout <int>,
    ## #   init_timeout <int>, idle_timeout <int>, max_processes <int>,
    ## #   min_processes <int>, max_conns_per_process <int>, load_factor <dbl>,
    ## #   memory_request <lgl>, memory_limit <lgl>, cpu_request <lgl>,
    ## #   cpu_limit <lgl>, amd_gpu_limit <lgl>, nvidia_gpu_limit <lgl>,
    ## #   service_account_name <lgl>, default_image_name <lgl>,
    ## #   default_environment_guid <lgl>, created_time <dttm>, …

``` r
content_list_by_tag(client, all_tags$DemoProject)
```

    ## # A tibble: 0 × 34
    ## # ℹ 34 variables: guid <chr>, name <chr>, title <chr>, description <chr>,
    ## #   access_type <chr>, connection_timeout <int>, read_timeout <int>,
    ## #   init_timeout <int>, idle_timeout <int>, max_processes <int>,
    ## #   min_processes <int>, max_conns_per_process <int>, load_factor <dbl>,
    ## #   created_time <dttm>, last_deployed_time <dttm>, bundle_id <chr>,
    ## #   app_mode <chr>, content_category <chr>, parameterized <lgl>,
    ## #   cluster_name <chr>, image_name <chr>, r_version <chr>, py_version <chr>, …

## Cleanup

Now we will clean up the demo tags that we created.

``` r
# Protect against tags already existing
if ("DemoProject" %in% names(start_tags) || "DemoAudience" %in% names(start_tags)) {
  stop("ERROR: One of the demo tags already exist for you! Beware lest they be deleted by this demo")
}

latest_tags <- get_tags(client)
delete_tag(client, latest_tags$DemoProject)
```

    ## Posit Connect API Client: 
    ##   Posit Connect Server: http://localhost:3939
    ##   Posit Connect API Key: ***********cvkN

``` r
delete_tag(client, latest_tags$DemoAudience)
```

    ## Posit Connect API Client: 
    ##   Posit Connect Server: http://localhost:3939
    ##   Posit Connect API Key: ***********cvkN

``` r
# TODO: delete content
```
