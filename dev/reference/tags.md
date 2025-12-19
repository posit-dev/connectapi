# Get all Tags on the server

Tag manipulation and assignment functions

## Usage

``` r
get_tags(src)

get_tag_data(src)

create_tag(src, name, parent = NULL)

create_tag_tree(src, ...)

delete_tag(src, tag)

get_content_tags(content)

set_content_tag_tree(content, ...)

set_content_tags(content, ...)

filter_tag_tree_id(tags, ids)

filter_tag_tree_chr(tags, pattern)
```

## Arguments

- src:

  The source object

- name:

  The name of the tag to create

- parent:

  optional. A `connect_tag_tree` object (as returned by `get_tags()`)
  pointed at the parent tag

- ...:

  Additional arguments

  Manage tags (requires Administrator role):

  - `get_tags()` - returns a "tag tree" object that can be traversed
    with `tag_tree$tag1$childtag`

  - `get_tag_data()` - returns a tibble of tag data

  - `create_tag()` - create a tag by specifying the Parent directly

  - `create_tag_tree()` - create tag(s) by specifying the "desired" tag
    tree hierarchy

  - `delete_tag()` - delete a tag (and its children). WARNING: will
    disassociate any content automatically

  Manage content tags:

  - `get_content_tags()` - return a `connect_tag_tree` object
    corresponding to the tags for a piece of content.

  - `set_content_tag_tree()` - attach a tag to content by specifying the
    desired tag tree

  - `set_content_tags()` - Set multiple tags at once by providing
    `connect_tag_tree` objects

  Search a tag tree:

  - `filter_tag_tree_chr()` - filters a tag tree based on a regex

  - `filter_tag_tree_id()` - filters a tag tree based on an id

- tag:

  A `connect_tag_tree` object (as returned by `get_tags()`)

- content:

  An R6 Content object, as returned by
  [`content_item()`](https://posit-dev.github.io/connectapi/dev/reference/content_item.md)

- tags:

  A `connect_tag_tree` object (as returned by `get_tags()`)

- ids:

  A list of `id`s to filter the tag tree by

- pattern:

  A regex to filter the tag tree by (it is passed to `grepl`)
