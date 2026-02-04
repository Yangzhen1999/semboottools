# Bootstrap CIs for Parameter Estimates

Functions for forming bootstrap confidence intervals for the parameter
estimates.

## Usage

``` r
parameterEstimates_boot(
  object,
  level = 0.95,
  boot_org_ratio = FALSE,
  boot_ci_type = c("perc", "bc", "bca.simple"),
  save_boot_est = TRUE,
  boot_pvalue = TRUE,
  boot_pvalue_min_size = 1000,
  standardized = FALSE,
  ...
)
```

## Arguments

- object:

  A 'lavaan'-class object, fitted with 'se = "boot"'.

- level:

  The level of confidence of the confidence intervals. Default is .95.

- boot_org_ratio:

  The ratio of (a) the distance of the bootstrap confidence limit from
  the point estimate to (b) the distance of the original confidence
  limit in `object` from the point estimate. Default is `FALSE`.

- boot_ci_type:

  The type of the bootstrapping confidence intervals. Support percentile
  confidence intervals (`"perc"`, the default) and bias-corrected
  confidence intervals (`"bc"` or `"bca.simple"`).

- save_boot_est:

  Whether the bootstrap estimates of the parameter estimates are saved.
  If saved, the bootstrap estimates of the free parameters will be
  stored in the attribute `boot_est_ustd`, while the bootstrap estimates
  of user-defined parameters, if any, will be stored in the attribute
  `boot_def`. Default is `TRUE`.

- boot_pvalue:

  Whether asymmetric bootstrap *p*-values are computed. Default is
  `TRUE`.

- boot_pvalue_min_size:

  Integer. The asymmetric bootstrap *p*-values will be computed only if
  the number of valid bootstrap estimates is at least this value.
  Otherwise, `NA` will be returned. If the number of valid bootstrap
  samples is less than this value, then `boot_pvalue` will be set to
  `FALSE`.

- standardized:

  The type of standardized estimates. The same argument of
  [`lavaan::parameterEstimates()`](https://rdrr.io/pkg/lavaan/man/parameterEstimates.html),
  and support all values supported by
  [`lavaan::parameterEstimates()`](https://rdrr.io/pkg/lavaan/man/parameterEstimates.html).
  It is recommended to use
  [`standardizedSolution_boot()`](https://Yangzhen1999.github.io/semboottools/reference/standardizedSolution_boot.md)
  or
  [`lavaan::standardizedSolution()`](https://rdrr.io/pkg/lavaan/man/standardizedSolution.html)
  because this function only report the point estimates of the
  standardized solution, without standard errors or confidence
  intervals.

- ...:

  Other arguments to be passed to
  [`lavaan::parameterEstimates()`](https://rdrr.io/pkg/lavaan/man/parameterEstimates.html).

## Value

The output of
[`lavaan::parameterEstimates()`](https://rdrr.io/pkg/lavaan/man/parameterEstimates.html),
with bootstrap confidence intervals appended to the right, with class
set to `sbt_ustd_boot`. It has a print method
([`print.sbt_ustd_boot()`](https://Yangzhen1999.github.io/semboottools/reference/print.sbt_ustd_boot.md))
that can be used to print the parameter estimates in a format similar to
that of the printout of the
[`summary()`](https://rdrr.io/r/base/summary.html) of a
[lavaan::lavaan](https://rdrr.io/pkg/lavaan/man/lavaan-class.html)
object.

## Details

`parameterEstimates_boot()` receives a
[lavaan::lavaan](https://rdrr.io/pkg/lavaan/man/lavaan-class.html)
object and form bootstrap confidence intervals for the parameter
estimates.

The function
[`store_boot()`](https://Yangzhen1999.github.io/semboottools/reference/store_boot.md)
should be called first to compute and store bootstrap estimates. This
function will then retrieve them.

### Bootstrap Confidence Intervals

It supports percentile and bias-corrected bootstrap confidence
intervals.

### Bootstrap Standard Errors

The standard errors are the standard deviation of the bootstrap
estimates.

### Bootstrap Asymmetric *p*-Values

If percentile bootstrap confidence interval is requested, asymmetric
bootstrap *p*-values are also computed, using the method presented in
Asparouhov and Muthén (2021).

## References

Asparouhov, A., & Muthén, B. (2021). Bootstrap p-value computation.
Retrieved from
https://www.statmodel.com/download/FAQ-Bootstrap%20-%20Pvalue.pdf

## See also

[`lavaan::parameterEstimates()`](https://rdrr.io/pkg/lavaan/man/parameterEstimates.html),
[`store_boot()`](https://Yangzhen1999.github.io/semboottools/reference/store_boot.md)

## Author

Shu Fai Cheung <https://orcid.org/0000-0002-9871-9448>.

## Examples

``` r
library(lavaan)
set.seed(5478374)
n <- 50
x <- runif(n) - .5
m <- .40 * x + rnorm(n, 0, sqrt(1 - .40))
y <- .30 * m + rnorm(n, 0, sqrt(1 - .30))
dat <- data.frame(x = x, y = y, m = m)
model <-
'
m ~ a*x
y ~ b*m
ab := a*b
'

# Should set bootstrap to at least 2000 in real studies
fit <- sem(model, data = dat, fixed.x = FALSE)
summary(fit)
#> lavaan 0.6-21 ended normally after 1 iteration
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                         5
#> 
#>   Number of observations                            50
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                                 0.020
#>   Degrees of freedom                                 1
#>   P-value (Chi-square)                           0.887
#> 
#> Parameter Estimates:
#> 
#>   Standard errors                             Standard
#>   Information                                 Expected
#>   Information saturated (h1) model          Structured
#> 
#> Regressions:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>   m ~                                                 
#>     x          (a)    0.569    0.343    1.660    0.097
#>   y ~                                                 
#>     m          (b)    0.219    0.153    1.430    0.153
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>    .m                 0.460    0.092    5.000    0.000
#>    .y                 0.570    0.114    5.000    0.000
#>     x                 0.078    0.016    5.000    0.000
#> 
#> Defined Parameters:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     ab                0.125    0.115    1.083    0.279
#> 
fit <- store_boot(fit,
                  do_bootstrapping = TRUE,
                  R = 100,
                  iseed = 1234)
est <- parameterEstimates_boot(fit)
#> Warning: The number of bootstrap samples (100) is less than 'boot_pvalue_min_size' (1000). Bootstrap p-values are not computed.
est
#> 
#> Bootstrapping:
#>                                     
#>  Valid Bootstrap Samples: 100       
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
#>          Estimate    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>  m ~                                                          
#>   x (a)     0.569 0.343 0.097 -0.103 1.240 0.326 -0.054  1.276
#>  y ~                                                          
#>   m (b)     0.219 0.153 0.153 -0.081 0.519 0.151 -0.060  0.572
#> 
#> Variances:
#>          Estimate    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>   .m        0.460 0.092 0.000  0.280 0.641 0.093  0.248  0.673
#>   .y        0.570 0.114 0.000  0.347 0.794 0.104  0.386  0.806
#>    x        0.078 0.016 0.000  0.048 0.109 0.012  0.052  0.106
#> 
#> Defined Parameters:
#>          Estimate    SE     p  CI.Lo CI.Up   bSE bCI.Lo bCI.Up
#>  ab (ab)    0.125 0.115 0.279 -0.101 0.350 0.135 -0.027  0.446
#> 
#> Footnote:
#> - SE: Original standard errors.
#> - p: Original p-values.
#> - CI.Lo, CI.Up: Original confidence intervals.
#> - bSE: Bootstrap standard errors.
#> - bCI.Lo, bCI.Up: Bootstrap confidence intervals.
```
