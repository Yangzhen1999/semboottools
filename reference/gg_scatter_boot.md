# Scatterplot Matrix of Bootstrap Estimates (ggplot2/GGally)

Generates a scatterplot matrix of the bootstrap estimates for two or
more model parameters using `ggplot2` and `GGally`, with optional
smoothing lines, confidence ellipses, and customizable density or
histogram plots on the diagonal.

## Usage

``` r
gg_scatter_boot(
  object,
  params,
  standardized = NULL,
  title = "Bootstrap Estimates",
  point_size = 1.8,
  point_alpha = 0.35,
  point_color = "#5DADE233",
  show_smooth = TRUE,
  smooth_method = "lm",
  smooth_se = FALSE,
  show_ellipse = TRUE,
  ellipse_level = 0.95,
  ellipse_color = "#8B0000CC",
  diag_type = c("both", "density", "hist", "blank"),
  hist_border_size = 0.2,
  bins = 30,
  dens_fill = "#5DADE233",
  dens_color = "#8B0000CC",
  hist_fill = "#5DADE233",
  hist_color = "#1B4F72",
  show_corr = TRUE,
  corr_text_size = 7,
  panel_border_color = "grey40",
  panel_border_size = 2,
  corr_digits = 2,
  show_mean_diag = TRUE,
  mean_line_color = "black",
  mean_linewidth = 0.7,
  mean_linetype = "dashed",
  output = c("draw", "ggplot")
)
```

## Arguments

- object:

  A bootstrap result object of class `"sbt_std_boot"` or
  `"sbt_ustd_boot"`.

- params:

  Character vector of parameter names to plot (≥ 2).

- standardized:

  Logical; whether to use standardized estimates.

- title:

  Plot title.

- point_size, point_alpha, point_color:

  Aesthetics for points in lower panels.

- show_smooth, smooth_method, smooth_se:

  Control the regression smoother in lower panels.

- show_ellipse, ellipse_level, ellipse_color:

  Confidence ellipse options in lower panels.

- diag_type:

  One of `"both"`, `"density"`, `"hist"`, `"blank"` for diagonal panels.

- hist_border_size:

  Histogram outline width in diagonal `"hist"`/`"both"`.

- bins, dens_fill, dens_color, hist_fill, hist_color:

  Diagonal panel styles.

- show_corr:

  Logical; if TRUE, show correlation coefficients in upper panels.

- corr_text_size, corr_digits:

  Text size and digits for upper-panel correlation.

- panel_border_color, panel_border_size:

  Panel border color and width for all panels.

- show_mean_diag, mean_line_color, mean_linewidth, mean_linetype:

  Draw a vertical mean line in diagonal panels.

- output:

  Either `"draw"` (print) or `"ggplot"` (return ggplot object).

## Value

Invisibly returns the `ggplot` object (or prints it if `output="draw"`).

## Details

The function `gg_scatter_boot()` is an enhanced ggplot2-based version of
[`scatter_boot()`](https://Yangzhen1999.github.io/semboottools/reference/hist_qq_boot.md),
designed to produce publication-quality scatterplot matrices of
bootstrap estimates. It can be applied to the output of
[`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md)
or
[`parameterEstimates_boot()`](https://Yangzhen1999.github.io/semboottools/reference/parameterEstimates_boot.md).

## See also

[`scatter_boot()`](https://Yangzhen1999.github.io/semboottools/reference/hist_qq_boot.md),
[`hist_qq_boot()`](https://Yangzhen1999.github.io/semboottools/reference/hist_qq_boot.md),
[`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md),
[`parameterEstimates_boot()`](https://Yangzhen1999.github.io/semboottools/reference/parameterEstimates_boot.md)
