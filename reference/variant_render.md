# Render a Variant

**\[experimental\]** Get details about renderings (i.e. render history)
or execute a variant on demand

## Usage

``` r
get_variant_renderings(variant)

variant_render(variant)
```

## Arguments

- variant:

  An R6 Variant object. As returned by
  [`get_variant()`](https://posit-dev.github.io/connectapi/reference/variant.md)
  or
  [`get_variant_default()`](https://posit-dev.github.io/connectapi/reference/variant.md)

## Details

- `get_variant_renderings()` returns all renderings / content for a
  particular variant. Returns a `tibble`

- `variant_render()` executes a variant on demand. Returns a
  `VariantTask` object

## See also

Other variant functions:
[`get_variants()`](https://posit-dev.github.io/connectapi/reference/variant.md)
