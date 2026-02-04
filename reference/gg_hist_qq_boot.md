# Diagnostic Plots of Bootstrap Estimates (ggplot2, Modular)

Produce diagnostic plots of bootstrap estimates using **ggplot2**.
Compared to
[`hist_qq_boot()`](https://Yangzhen1999.github.io/semboottools/reference/hist_qq_boot.md)
(base graphics), this function is *modular* and *modern*: optional
layers (histogram, mean line, CI, SD arrow, QQ), and the ability to
return only the data or the ggplot object for further customization.

## Usage

``` r
gg_hist_qq_boot(
  object,
  param,
  standardized = NULL,
  bins = 35,
  show_ci = TRUE,
  show_mean = TRUE,
  show_sd_arrow = TRUE,
  show_qq = TRUE,
  show_hist = TRUE,
  text_size = 3,
  ci_label_digits = 3,
  mean_label_digits = 3,
  sd_label_digits = 3,
  sd_clip_to_density = TRUE,
  sd_arrow_height = 0.58,
  trim_quantiles = NULL,
  ci_line_color = "#D62728",
  dens_line_color = "#8B0000CC",
  bar_fill = "#5DADE233",
  bar_color = "#1B4F72",
  enforce_serif = TRUE,
  theme_override = NULL,
  dens_adjust = 1,
  dens_from = NULL,
  dens_to = NULL,
  show_boot_mean = TRUE,
  point_color = "#000000",
  boot_mean_color = "#AA3377",
  output = c("draw", "ggplot", "data"),
  return = NULL,
  ...
)
```

## Arguments

- object:

  A `lavaan` object with stored bootstrap results, or an `sbt_std_boot`
  (from
  [`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md))
  or `sbt_ustd_boot` (from
  [`parameterEstimates_boot()`](https://Yangzhen1999.github.io/semboottools/reference/parameterEstimates_boot.md))
  object.

- param:

  Character. Name of the parameter to plot (as in
  [`coef()`](https://rdrr.io/r/stats/coef.html) or `"lhs op rhs"`).

- standardized:

  Logical. Use standardized estimates. Ignored for `sbt_*` inputs.

- bins:

  Integer. Number of histogram bins when `show_hist = TRUE`. Default
  `35`.

- show_ci:

  Logical. Draw CI vertical dashed lines and labels. Default `TRUE`.

- show_mean:

  Logical. Draw **point estimate** vertical line and label. Default
  `TRUE`.

- show_sd_arrow:

  Logical. Draw ±SD double‐headed arrow and label. Default `TRUE`.

- show_qq:

  Logical. Add a side-by-side QQ plot (uses `patchwork` if available).
  Default `TRUE`.

- show_hist:

  Logical. Draw histogram (otherwise density only). Default `TRUE`.

- text_size:

  Numeric. Font size for labels. Default `3`.

- ci_label_digits, mean_label_digits, sd_label_digits:

  Integer digits for labels. Default `3`.

- sd_clip_to_density:

  Logical. Clip SD arrow within density curve span. Default `TRUE`.

- sd_arrow_height:

  Numeric in (0,1\]. Relative height for the SD arrow. Default `0.58`.

- trim_quantiles:

  Length-2 numeric. Trim x-axis by quantiles (e.g., `c(.01,.99)`).
  `NULL` = no trimming.

- ci_line_color:

  Color for CI lines. Default `"#D62728"`.

- dens_line_color:

  Color for density curve. Default `"#8B0000CC"`.

- bar_fill, bar_color:

  Histogram fill/border colors. Defaults `"#5DADE233"` / `"#1B4F72"`.

- enforce_serif:

  Logical. Use serif base family in the theme. Default `TRUE`.

- theme_override:

  Optional
  [`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html)
  added on top of base theme.

- dens_adjust:

  Numeric ≥ 0. Bandwidth adjust for
  [`stats::density()`](https://rdrr.io/r/stats/density.html). Default
  `1`.

- dens_from, dens_to:

  Optional numeric. Force `from`/`to` range for
  [`density()`](https://rdrr.io/r/stats/density.html).

- show_boot_mean:

  Logical. Draw **bootstrap mean** vertical line. Default `TRUE`.

- point_color:

  Color for the **point estimate** line. Default `"#000000"`.

- boot_mean_color:

  Color for the **bootstrap mean** line. Default `"#AA3377"`.

- output:

  One of `"draw"`, `"ggplot"`, or `"data"`. What to return/draw. Default
  `"draw"`.

- return:

  Deprecated. Backward-compatible alias of `output`; if supplied, it
  overrides `output`.

- ...:

  Additional arguments passed to ggplot layers (e.g.,
  `geom_histogram()`).

## Value

- If `output = "draw"`: draws the plot and invisibly returns the ggplot
  object;

- If `output = "ggplot"`: returns a ggplot object (no drawing);

- If `output = "data"`: returns a list with

  - `t`: bootstrap draws;

  - `t0`: point estimate;

  - `sd`: sample standard deviation;

  - `hist`: data frame for histogram layer;

  - `dens`: data frame for density curve (`x`, `y`);

  - `ci`: list with `lower`, `upper`, `y_lower`, `y_upper`.

If `output = "draw"`, draws the plot and (invisibly) returns the ggplot
object; if `output = "ggplot"`, returns the ggplot (no drawing); if
`output = "data"`, returns a list with `t`, `t0`, `sd`, `hist`, `dens`,
and `ci` (class `"sbt_boot_plotdata"`).

## Details

- For free (unstandardized) parameters, bootstrap draws are extracted
  directly from the `lavaan` object;

- For user-defined parameters or standardized solutions,
  [`store_boot()`](https://Yangzhen1999.github.io/semboottools/reference/store_boot.md)
  or
  [`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md)
  must be called in advance;

- Supports objects of class `sbt_std_boot` (standardized) and
  `sbt_ustd_boot` (unstandardized).

**Return mode**

- `output = "draw"`: draw the plot (default) and invisibly return the
  ggplot object;

- `output = "ggplot"`: return the ggplot object without drawing;

- `output = "data"`: return a list containing the data frames for
  histogram, density, and CI positions (class `"sbt_boot_plotdata"`).

**Axis control**

- By default, the x-axis has a small margin beyond the observed range;
  set `trim_quantiles = c(.01, .99)` to crop extreme tails by quantiles.

**Optional layers**

- `show_hist`, `show_mean`, `show_ci`, `show_sd_arrow`, `show_qq`.

## References

Rousselet, G. A., Pernet, C. R., & Wilcox, R. R. (2021). The percentile
bootstrap: A primer with step-by-step instructions in R. *Advances in
Methods and Practices in Psychological Science*, 4(1), 1–10.
[doi:10.1177/2515245920911881](https://doi.org/10.1177/2515245920911881)

## See also

[`store_boot()`](https://Yangzhen1999.github.io/semboottools/reference/store_boot.md),
[`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md),
[`hist_qq_boot()`](https://Yangzhen1999.github.io/semboottools/reference/hist_qq_boot.md)
