# Convert objects to integration class

Convert objects to integration class

## Usage

``` r
as_integration(x, client)
```

## Arguments

- x:

  An object to convert to an integration.

- client:

  The Connect client object where the integration comes from.

## Value

An integration object. The object has all the fields from the
integrations endpoint (see
[`get_integrations()`](https://posit-dev.github.io/connectapi/dev/reference/get_integrations.md))
and a Connect client as a `client` attribute (`attr(x, "client")`)
