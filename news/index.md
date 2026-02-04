# Changelog

## semboottools 0.1.2

### Miscellaneous

- Used `linewidth` instead of `size` in
  [`ggplot2::geom_histogram()`](https://ggplot2.tidyverse.org/reference/geom_histogram.html)
  to suppress a warning. (0.1.1.1)

- Updated vignettes to use `iseed` and `ncpus`. (0.1.2)

- Updated references in vignettes.

## semboottools 0.1.1

CRAN release: 2025-09-17

### New functions

- jab_after_boot(): Computes Jackknife-after-Bootstrap influence values
  for a single parameter from a lavaan bootstrap model, with an optional
  diagnostic plot.
- gg_hist_qq_boot(): Creates ggplot2-based diagnostic plots of bootstrap
  estimates; a modular version of hist_qq_boot() supporting optional
  layers and customization.
