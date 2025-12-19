# Promote content from one Connect server to another

Promote content from one Connect server to another

## Usage

``` r
promote(from, to, to_key, from_key, name)
```

## Arguments

- from:

  The url for the server containing the content (the originating server)

- to:

  The url for the server where the content will be deployed (the
  destination server)

- to_key:

  An API key on the destination "to" server. If the destination content
  is going to be updated, the API key must belong to a user with
  collaborator access on the content that will be updated. If the
  destination content is to be created new, the API key must belong to a
  user with publisher privileges.

- from_key:

  An API key on the originating "from" server. The API key must belong
  to a user with collaborator access to the content to be promoted.

- name:

  The name of the content on the originating "from" server. If content
  with the same name is found on the destination server, the content
  will be updated. If no content on the destination server has a
  matching name, a new endpoint will be created.

## Value

The URL for the content on the destination "to" server
