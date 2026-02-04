# parameterEstimates_boot

This vignette is a quick guide to use
[`parameterEstimates_boot()`](https://Yangzhen1999.github.io/semboottools/reference/parameterEstimates_boot.md)
in the package
[`semboottools`](https://yangzhen1999.github.io/semboottools/),
described in Yang & Cheung ([2026](#ref-yang_forming_2026)), to form
bootstrap confidence intervals for the unstandardized estimates in a
model fitted by `lavaan`.

The following two packages are needed:

``` r
library(semboottools)
library(lavaan)
#> This is lavaan 0.6-21
#> lavaan is FREE software! Please report any bugs.
```

## Function Syntax

``` r
parameterEstimates_boot(object,
                        level = .95,
                        standardized = FALSE,
                        boot_org_ratio = FALSE,
                        boot_ci_type = c("perc", "bc", "bca.simple"),
                        save_boot_est = TRUE,
                        boot_pvalue = TRUE,
                        boot_pvalue_min_size = 1000,
                        ...)
```

## Arguments

| Argument               | Description                                                                                                                                                                                                                                                                                                                                                           |
|------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `object`               | A model fitted by `lavaan`.                                                                                                                                                                                                                                                                                                                                           |
| `level`                | Confidence level for the confidence intervals. For example, `.95` gives 95% confidence intervals.                                                                                                                                                                                                                                                                     |
| `standardized`         | Whether to return standardized estimates. Same as in [`lavaan::parameterEstimates()`](https://rdrr.io/pkg/lavaan/man/parameterEstimates.html). You can use `"std.all"`, `"std.lv"`, etc. For detailed standardized results with CIs, use [`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md) instead. |
| `boot_org_ratio`       | Whether to calculate how wide the bootstrap confidence interval is compared to the original confidence interval (from delta method). Useful to compare the two methods.                                                                                                                                                                                               |
| `boot_ci_type`         | Method for forming bootstrap confidence intervals. `"perc"` gives percentile intervals; `"bc"` and `"bca.simple"` give bias-corrected intervals.                                                                                                                                                                                                                      |
| `save_boot_est`        | Whether to save the bootstrap estimates in the result. Saved in attributes `boot_est_ustd` (free parameters) and `boot_def` (user-defined parameters) if `TRUE`.                                                                                                                                                                                                      |
| `boot_pvalue`          | Whether to compute asymmetric *p*-values based on bootstrap results. Only available when percentile confidence intervals are used.                                                                                                                                                                                                                                    |
| `boot_pvalue_min_size` | Minimum number of valid bootstrap samples needed to compute asymmetric *p*-values. If fewer samples are available, *p*-values will not be computed and will be shown as `NA`.                                                                                                                                                                                         |
| `...`                  | Additional arguments passed to [`lavaan::parameterEstimates()`](https://rdrr.io/pkg/lavaan/man/parameterEstimates.html).                                                                                                                                                                                                                                              |

## Example

### Data and Model

``` r
# Set seed for reproducibility
set.seed(1234)

# Generate data
n <- 1000
x <- runif(n) - 0.5
m <- 0.20 * x + rnorm(n)
y <- 0.17 * m + rnorm(n)
dat <- data.frame(x, y, m)

# Specify mediation model in lavaan syntax
mod <- '
  m ~ a * x
  y ~ b * m + cp * x
  ab := a * b
  total := a * b + cp
'
```

### Basic usage: default settings

The function
[`parameterEstimates_boot()`](https://Yangzhen1999.github.io/semboottools/reference/parameterEstimates_boot.md)
can be used to add bootstrap estimates to an output of `lavaan`. This
method is useful when both the default standard errors and *p*-values,
such as those by maximum likelihood (ML), and the bootstrap standard
errors and *p*-values are desired.

``` r
# Ensure bootstrap estimates are stored
# `R`, the number of bootstrap samples, should be ≥2000 in real studies.
# `parallel` should be used unless fitting the model is fast.
# Set `ncpus` to a larger value or omit it in real studies.
# `iseed` is set to make the results reproducible.
fit <- sem(mod,
           data = dat,
           fixed.x = FALSE)
fit <- store_boot(fit,
                  R = 500,
                  parallel = "snow",
                  ncpus = 2,
                  iseed = 1248)
est_boot <- parameterEstimates_boot(fit)
#> Warning in parameterEstimates_boot(fit): The number of bootstrap samples (500)
#> is less than 'boot_pvalue_min_size' (1000). Bootstrap p-values are not
#> computed.
print(est_boot)
#> 
#> Bootstrapping:
#>                                     
#>  Valid Bootstrap Samples: 500       
#>  Level of Confidence:     95.0%     
#>  CI Type:                 Percentile
#> 
#> Parameter Estimates Settings:
#>                                              
#>  Standard errors:                  Standard  
#>  Information:                      Expected  
#>  Information saturated (h1) model: Structured
#> 
#> Regressions:
#>                Estimate    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>  m ~                                                                
#>   x (a)           0.089 0.103 0.386 -0.113 0.291 0.100 -0.136  0.264
#>  y ~                                                                
#>   m (b)           0.192 0.034 0.000  0.125 0.260 0.036  0.123  0.264
#>   x (cp)         -0.018 0.112 0.871 -0.238 0.202 0.112 -0.228  0.205
#> 
#> Variances:
#>                Estimate    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>   .m              0.898 0.040 0.000  0.819 0.977 0.038  0.829  0.970
#>   .y              1.065 0.048 0.000  0.972 1.159 0.046  0.972  1.147
#>    x              0.085 0.004 0.000  0.077 0.092 0.002  0.080  0.090
#> 
#> Defined Parameters:
#>                Estimate    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>  ab (ab)          0.017 0.020 0.392 -0.022 0.056 0.019 -0.028  0.053
#>  total (total)   -0.001 0.114 0.993 -0.224 0.222 0.113 -0.211  0.213
#> 
#> Footnote:
#> - SE: Original standard errors.
#> - p: Original p-values.
#> - CI.Lo, CI.Up: Original confidence intervals.
#> - bSE: Bootstrap standard errors.
#> - bCI.Lo, bCI.Up: Bootstrap confidence intervals.
```

### parameterEstimates_boot(): Different Options

Additional options to customize the output of
[`parameterEstimates_boot()`](https://Yangzhen1999.github.io/semboottools/reference/parameterEstimates_boot.md).

``` r

# Change confidence level to 99%
est_boot <- parameterEstimates_boot(fit,
                                    level = 0.99)
# Use bias-corrected (BC) bootstrap confidence intervals
est_boot <- parameterEstimates_boot(fit,
                                    boot_ci_type = "bc")
# Turn off asymmetric bootstrap p-values
est_boot <- parameterEstimates_boot(fit,
                                    boot_pvalue = FALSE)
# Do not save bootstrap estimates (for memory saving)
est_boot <- parameterEstimates_boot(fit,
                                    save_boot_est = FALSE)
# Compute and display bootstrap-to-original CI ratio
est_boot <- parameterEstimates_boot(fit,
                                    boot_org_ratio = TRUE)
# Combine options: BC CI, 99% level, no p-values
est_boot <- parameterEstimates_boot(fit,
                                    level = 0.99,
                                    boot_ci_type = "bc",
                                    boot_pvalue = FALSE)
```

### print(): Options

Additional options to customize the printout of the output of
[`parameterEstimates_boot()`](https://Yangzhen1999.github.io/semboottools/reference/parameterEstimates_boot.md).

``` r
# Print with more decimal places (e.g., 5 digits)
print(est_boot,
      nd = 5)
# Print in lavaan-style text format (similar to summary())
print(est_boot,
      output = "text")
# Print as a clean data frame table
print(est_boot,
      output = "table")
# Drop specific columns (e.g., "Z") in lavaan.printer format
print(est_boot,
      drop_cols = "Z")
# Combine options: 5 decimal digits, text format
print(est_boot,
      nd = 5,
      output = "text")
```

## Reference(s)

Yang, W., & Cheung, S. F. (2026). Forming bootstrap confidence intervals
and examining bootstrap distributions of standardized coefficients in
structural equation modelling: A simplified workflow using the R package
semboottools. *Behavior Research Methods*, *58*(2), 38.
<https://doi.org/10.3758/s13428-025-02911-z>
