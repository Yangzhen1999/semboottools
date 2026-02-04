# Jackknife-after-Bootstrap (JAB) influence for lavaan bootstrap results

Compute Jackknife-after-Bootstrap (JAB) influence values for a single
model parameter and diagnose observation-level influence by comparing
the full bootstrap distribution with leave-one-out (LOO)
subdistributions obtained via `boot.idx` (stored by
`store_boot(keep.idx = TRUE)`).

The ALL-summary (mean/SE/CI) is taken directly and consistently from
[`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md)
(standardized case) or
[`parameterEstimates_boot()`](https://Yangzhen1999.github.io/semboottools/reference/parameterEstimates_boot.md)
(unstandardized case). JAB influence is defined as \\I_j =
n\\\bar\theta\_{(-j)} - \bar\theta\\\\, where \\\bar\theta\\ is the
bootstrap mean over all replicates, and \\\bar\theta\_{(-j)}\\ is the
bootstrap mean over the replicates that exclude observation \\j\\.

## Usage

``` r
jab_after_boot(
  fit,
  param,
  standardized = TRUE,
  top_k = 5L,
  ci_level = 0.95,
  min_keep = NULL,
  plot = FALSE,
  plot_engine = c("ggplot2", "base"),
  ylab_override = NULL,
  verbose = TRUE,
  font_family = "sans"
)
```

## Arguments

- fit:

  A `lavaan` object for which `store_boot(keep.idx = TRUE)` has been
  called. Must contain `fit@external$sbt_boot_ustd` (with `boot.idx`
  attribute) and typically `sbt_boot_std`.

- param:

  Character(1). Target parameter. Accepts `"lhs op rhs"`, a `":="`
  label, or a free-parameter label.

- standardized:

  Logical. If `TRUE`, use standardized bootstrap; else unstandardized.

- top_k:

  Integer. Number of top cases (by `|JAB_value|`) to report.

- ci_level:

  Numeric (0,1). Percentile CI level for LOO subdistributions.

- min_keep:

  Integer. Minimum number of bootstrap replicates kept in each LOO
  subset; default `max(30, floor(0.2 * B))`.

- plot:

  Logical. If `TRUE`, draw a JAB diagnostic plot.

- plot_engine:

  Character. Plot engine for `plot = TRUE`. One of `"ggplot2"` or
  `"base"`. Default `"ggplot2"` if available, otherwise `"base"`.

- ylab_override:

  Optional character. Override the default y-axis label in the plot.

- verbose:

  Logical. If `TRUE`, print compact summaries.

- font_family:

  Character. Graphics font family (e.g., `"serif"`, `"sans"`,
  `"Times New Roman"`).

## Value

A list with:

- `param`:

  The target parameter string.

- `standardized`:

  Logical flag as input.

- `full_summary`:

  Data frame with ALL distribution summary: `scope="ALL"`, `param`,
  `mean`, `SE`, `CI.Lo`, `CI.Up`.

- `cases_summary`:

  Data frame (top `top_k`) with columns: `case`, `JAB_value`, `mean`,
  `SE`, `CI.Lo`, `CI.Up`.

- `F`:

  The occurrence matrix \\B \times n\\.

- `tstar`:

  Full bootstrap vector for `param`.

## Details

Parameter identification is robust: it accepts `"lhs op rhs"`, `":="`
user-defined name, and *label*. For unstandardized cases, if `label` is
given and the column is missing in `attr(unstd_boot, "boot_est_ustd")`,
the function will fall back to the raw matrix
`fit@external$sbt_boot_ustd` if a column with that label exists (e.g.,
`"b"`), keeping SE/CI from the
[`parameterEstimates_boot()`](https://Yangzhen1999.github.io/semboottools/reference/parameterEstimates_boot.md)
row if available.

## See also

[`store_boot`](https://Yangzhen1999.github.io/semboottools/reference/store_boot.md),
[`standardizedSolution_boot`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md),
[`parameterEstimates_boot`](https://Yangzhen1999.github.io/semboottools/reference/parameterEstimates_boot.md)
