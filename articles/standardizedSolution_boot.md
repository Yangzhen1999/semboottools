# semboottools::standardizedSolution_boot

This vignette is a quick guide to use
[`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md)
in the package
[`semboottools`](https://yangzhen1999.github.io/semboottools/),
described in Yang & Cheung ([2026](#ref-yang_forming_2026)), to form
bootstrap confidence intervals for the standardized solution in a model
fitted by `lavaan`.

The following two packages are needed:

``` r
library(semboottools)
library(lavaan)
#> This is lavaan 0.6-21
#> lavaan is FREE software! Please report any bugs.
```

## Function Syntax

``` r
standardizedSolution_boot(object,
                          level = .95,
                          type = "std.all",
                          boot_delta_ratio = FALSE,
                          boot_ci_type = c("perc", "bc", "bca.simple"),
                          save_boot_est_std = TRUE,
                          boot_pvalue = TRUE,
                          boot_pvalue_min_size = 1000,
                          ...)
```

## Arguments

| Argument               | Description                                                                                                                                                                    |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `object`               | A model fitted by `lavaan`.                                                                                                                                                    |
| `level`                | Confidence level for the confidence intervals. For example, `.95` gives 95% confidence intervals.                                                                              |
| `type`                 | Type of standardized coefficients. Same as in [`lavaan::standardizedSolution()`](https://rdrr.io/pkg/lavaan/man/standardizedSolution.html), such as `"std.all"` or `"std.lv"`. |
| `boot_delta_ratio`     | Whether to calculate how wide the bootstrap confidence interval is compared to the usual confidence interval (delta method). Useful for comparing both methods.                |
| `boot_ci_type`         | Method for forming bootstrap confidence intervals. `"perc"` gives percentile intervals; `"bc"` and `"bca.simple"` give bias-corrected intervals.                               |
| `save_boot_est_std`    | Whether to save the bootstrap estimates of standardized coefficients in the result. Saved in the attribute `boot_est_std` if `TRUE`.                                           |
| `boot_pvalue`          | Whether to compute asymmetric *p*-values based on bootstrap results. Only available when percentile confidence intervals are used.                                             |
| `boot_pvalue_min_size` | Minimum number of valid bootstrap samples needed to compute asymmetric *p*-values. If fewer samples are available, *p*-values will not be computed and will be shown as `NA`.  |
| `...`                  | Additional arguments passed to [`lavaan::standardizedSolution()`](https://rdrr.io/pkg/lavaan/man/standardizedSolution.html).                                                   |

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

### Basic Usage: Default Settings

The function
[`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md)
can be used directly when bootstrap standard errors and confidence
intervals are requested when fitting the model (using `se = "boot"`):

``` r
# `bootstrap` should use ≥2000 in real studies.
# `parallel` should be used unless fitting the model is fast.
# Set `ncpus` to a larger value or omit it in real studies.
# `iseed` is set to make the results reproducible.
fit <- sem(mod,
           data = dat,
           se = "boot",
           bootstrap = 500,
           parallel = "snow",
           ncpus = 2,
           iseed = 1248)
std_boot <- standardizedSolution_boot(fit)
#> Warning in standardizedSolution_boot(fit): The number of bootstrap samples
#> (500) is less than 'boot_pvalue_min_size' (1000). Bootstrap p-values are not
#> computed.
print(std_boot)
#> 
#> Bootstrapping:
#>                                     
#>  Valid Bootstrap Samples: 500       
#>  Level of Confidence:     95.0%     
#>  CI Type:                 Percentile
#>  Standardization Type:    std.all   
#> 
#> Parameter Estimates Settings:
#>                                                 
#>  Standard errors:                      Bootstrap
#>  Number of requested bootstrap draws:  500      
#>  Number of successful bootstrap draws: 500      
#> 
#> Regressions:
#>                   Std    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>  m ~                                                              
#>   x (a)         0.027 0.031 0.370 -0.033 0.087 0.031 -0.042  0.079
#>  y ~                                                              
#>   m (b)         0.174 0.031 0.000  0.112 0.235 0.031  0.115  0.237
#>   x (cp)       -0.005 0.031 0.870 -0.066 0.056 0.031 -0.063  0.057
#> 
#> Variances:
#>                   Std    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>   .m            0.999 0.002 0.000  0.996 1.003 0.002  0.994  1.000
#>   .y            0.970 0.011 0.000  0.948 0.991 0.011  0.943  0.986
#>    x            1.000                                             
#> 
#> Defined Parameters:
#>                   Std    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>  ab (ab)        0.005 0.005 0.371 -0.006 0.015 0.005 -0.008  0.014
#>  total (total) -0.000 0.031 0.993 -0.062 0.061 0.031 -0.059  0.059
#> 
#> Footnote:
#> - Std: Standardized estimates.
#> - SE: Delta method standard errors.
#> - p: Delta method p-values.
#> - CI.Lo, CI.Up: Delta method confidence intervals.
#> - bSE: Bootstrap standard errors.
#> - bCI.Lo, bCI.Up: Bootstrap confidence intervals.
```

If bootstrap standard errors are not requested when fitting the model,
call
[`store_boot()`](https://Yangzhen1999.github.io/semboottools/reference/store_boot.md)
first. It does the following:

- Does bootstrapping using
  [`bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html).

- Stores the bootstrap estimates in the object and returns it. This
  object can be used as an usual `lavaan` output object.

This method is useful when both the default standard errors and
*p*-values, such as those by maximum likelihood (ML), and the bootstrap
standard errors and *p*-values are desired.

The function
[`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md)
can then be used directly on the output of
[`store_boot()`](https://Yangzhen1999.github.io/semboottools/reference/store_boot.md).

``` r
# The function `store_boot` also does not require
# 'se = "boot"' when fitting the model.
# `R`, the number of bootstrap samples, should be ≥2000 in real studies.
# `parallel` should be used unless fitting the model is fast.
# Set `ncpus` to a larger value or omit it in real studies.
# `iseed` is set to make the results reproducible.
fit2 <- sem(mod,
            data = dat,
            fixed.x = FALSE)
fit2 <- store_boot(fit2,
                   R = 500,
                   parallel = "snow",
                   ncpus = 2,
                   iseed = 1248)
std_boot2 <- standardizedSolution_boot(fit2)
#> Warning in standardizedSolution_boot(fit2): The number of bootstrap samples
#> (500) is less than 'boot_pvalue_min_size' (1000). Bootstrap p-values are not
#> computed.
print(std_boot)
#> 
#> Bootstrapping:
#>                                     
#>  Valid Bootstrap Samples: 500       
#>  Level of Confidence:     95.0%     
#>  CI Type:                 Percentile
#>  Standardization Type:    std.all   
#> 
#> Parameter Estimates Settings:
#>                                                 
#>  Standard errors:                      Bootstrap
#>  Number of requested bootstrap draws:  500      
#>  Number of successful bootstrap draws: 500      
#> 
#> Regressions:
#>                   Std    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>  m ~                                                              
#>   x (a)         0.027 0.031 0.370 -0.033 0.087 0.031 -0.042  0.079
#>  y ~                                                              
#>   m (b)         0.174 0.031 0.000  0.112 0.235 0.031  0.115  0.237
#>   x (cp)       -0.005 0.031 0.870 -0.066 0.056 0.031 -0.063  0.057
#> 
#> Variances:
#>                   Std    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>   .m            0.999 0.002 0.000  0.996 1.003 0.002  0.994  1.000
#>   .y            0.970 0.011 0.000  0.948 0.991 0.011  0.943  0.986
#>    x            1.000                                             
#> 
#> Defined Parameters:
#>                   Std    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>  ab (ab)        0.005 0.005 0.371 -0.006 0.015 0.005 -0.008  0.014
#>  total (total) -0.000 0.031 0.993 -0.062 0.061 0.031 -0.059  0.059
#> 
#> Footnote:
#> - Std: Standardized estimates.
#> - SE: Delta method standard errors.
#> - p: Delta method p-values.
#> - CI.Lo, CI.Up: Delta method confidence intervals.
#> - bSE: Bootstrap standard errors.
#> - bCI.Lo, bCI.Up: Bootstrap confidence intervals.
```

### standardizedSolution_boot(): Different Options

Additional options to customize the output of
[`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md).

``` r
# Change confidence level
std_boot <- standardizedSolution_boot(fit,
                                      level = 0.99)
# Use bias-corrected bootstrap CIs
std_boot <- standardizedSolution_boot(fit,
                                      boot_ci_type = "bc")
std_boot <- standardizedSolution_boot(fit,
                                      boot_ci_type = "bca.simple")
# Compute delta ratio
std_boot <- standardizedSolution_boot(fit,
                                      boot_delta_ratio = TRUE)
# Do not save bootstrap estimates
std_boot <- standardizedSolution_boot(fit,
                                      save_boot_est_std = FALSE)
# Turn off asymmetric bootstrap p-values
std_boot <- standardizedSolution_boot(fit,
                                      boot_pvalue = FALSE)
# Combine options
std_boot <- standardizedSolution_boot(fit,
                                      boot_ci_type = "bc",
                                      boot_delta_ratio = TRUE)
```

### print(): Options

Additional options to customize the printout of the output of
[`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md).

``` r

# Print standardized solution in friendly format
print(std_boot,
      output = "text")
# Print with more decimal places (e.g., 5 decimal digits)
print(std_boot,
      nd = 5)
# Print only bootstrap confidence intervals
print(std_boot,
      boot_ci_only = TRUE)
# Print both unstandardized and standardized solution
print(std_boot,
      standardized_only = FALSE)
# Combine options: more decimals + show both solutions
print(std_boot,
      nd = 4, standardized_only = FALSE)
# Combine options: show only bootstrap CI, 5 decimal places
print(std_boot,
      boot_ci_only = TRUE,
      nd = 5)
```

## Reference(s)

Yang, W., & Cheung, S. F. (2026). Forming bootstrap confidence intervals
and examining bootstrap distributions of standardized coefficients in
structural equation modelling: A simplified workflow using the R package
semboottools. *Behavior Research Methods*, *58*(2), 38.
<https://doi.org/10.3758/s13428-025-02911-z>
