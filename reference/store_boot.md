# Compute and Store Bootstrap Estimates

This function computes bootstrap estimates of a fitted structural
equation model and stores the estimates for further processing.

## Usage

``` r
store_boot(
  object,
  type = "std.all",
  do_bootstrapping = TRUE,
  R = 1000,
  boot_type = "ordinary",
  parallel = c("no", "multicore", "snow"),
  ncpus = parallel::detectCores(logical = FALSE) - 1,
  iseed = NULL,
  keep.idx = FALSE,
  bootstrapLavaan_args = list()
)
```

## Arguments

- object:

  A 'lavaan'-class object, fitted with 'se = "boot"'.

- type:

  The type of standard estimates. The same argument of
  [`lavaan::standardizedSolution()`](https://rdrr.io/pkg/lavaan/man/standardizedSolution.html),
  and support all values supported by
  [`lavaan::standardizedSolution()`](https://rdrr.io/pkg/lavaan/man/standardizedSolution.html).
  Default is `"std.all"`.

- do_bootstrapping:

  If `TRUE` and bootstrapping was not requested when fitting the model,
  bootstrapping will be done using
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html).
  Default is `TRUE`.

- R:

  If
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html)
  is called (see `do_bootstrapping`), this is the number of bootstrap
  samples, to be used by
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html).

- boot_type:

  If
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html)
  is called (see `do_bootstrapping`), this is type of bootstrapping, to
  be passed to the argument `type` of
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html).
  Default is `"ordinary"`. See the help page of
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html)
  for details.

- parallel:

  If
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html)
  is called (see `do_bootstrapping`), whether parallel processing will
  be used. to be passed to the argument of the same name in
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html).
  Default is `"no"`. Can be `"snow"` or `"multicore"`. See the help page
  of
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html)
  for details.

- ncpus:

  If
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html)
  is called (see `do_bootstrapping`), and parallel processing is to be
  used, this is the number of CPU cores to use, to be passed to the
  argument of the same name in
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html).
  Default is `parallel::detectCores(logical = FALSE) - 1`, the number of
  physical cores minus 1, different from the default of
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html)
  but identical to the default of
  [`lavaan::sem()`](https://rdrr.io/pkg/lavaan/man/sem.html) and
  [`lavaan::cfa()`](https://rdrr.io/pkg/lavaan/man/cfa.html).

- iseed:

  If
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html)
  is called (see `do_bootstrapping`), this should be an integer used to
  generate reproducible bootstrap results, to be passed to the argument
  of the same name in
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html).
  Default is `NULL` but it should nearly always be set to an arbitrary
  integer. See the help page of
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html)
  for details.

- keep.idx:

  Whether the indices of cases selected in each bootstrap sample is to
  be stored. To be passed to the argument of the same name in
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html).
  Default is `FALSE`.

- bootstrapLavaan_args:

  A named list of additional arguments to be passed to
  [`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html).
  Note that the other arguments in `store_boot()` takes precedence,
  overriding arguments of the same names in this list, if any.

## Value

The original `lavaan` object is returned with the following objects
stored in the `external` slot:

- `sbt_boot_std`: The matrix of bootstrap estimates in the standardized
  solution.

- `sbt_boot_def`: The matrix of bootstrap estimates of user-defined
  parameters, if any.

- `sbt_boot_ustd`: The matrix of bootstrap estimates of free parameters,
  if bootstrapping is not requested when fitting the model (i.e., `se`
  is not set to `"boot"` or `"bootstrap"` when fitting the model in
  `lavaan`).

## Details

The function `store_boot()` receives a
[lavaan::lavaan](https://rdrr.io/pkg/lavaan/man/lavaan-class.html)
object, optionally fitted with bootstrapping standard errors requested,
and compute and store the bootstrap estimates of user-defined parameters
and estimates in the standardized solution.

If bootstrapping was not requested when fitting the model (i.e., `se`
not set to `"boot"` or `"bootstrap"`), then bootstrapping will be
conducted using
[`lavaan::bootstrapLavaan()`](https://rdrr.io/pkg/lavaan/man/bootstrap.html)
to compute bootstrap estimates of free parameters. Otherwise, the stored
bootstrap estimates will be used in subsequent steps.

For standardized solution bootstrap estimates, it works by calling
[`lavaan::standardizedSolution()`](https://rdrr.io/pkg/lavaan/man/standardizedSolution.html)
with the bootstrap estimates of free parameters in each bootstrap sample
to compute the standardized estimates in each sample.

For user-defined parameters, it works by calling the function used to
compute user-defined parameters with the bootstrap estimates of free
parameters in each bootstrap samples to compute the user-defined
parameters.

The bootstrap estimates are then stored in the `external` slot of the
fit object for further processing.

## Author

Shu Fai Cheung <https://orcid.org/0000-0002-9871-9448>. Based on
`semhelpinghands::standardizedSolution_boot_ci()`, which was originally
proposed in an issue at GitHub
<https://github.com/simsem/semTools/issues/101#issue-1021974657>,
inspired by a discussion at the Google group for lavaan
<https://groups.google.com/g/lavaan/c/qQBXSz5cd0o/m/R8YT5HxNAgAJ>.
Unlike `semhelpinghands::standardizedSolution_boot_ci()`, this function
only computes and stores the bootstrap estimates.

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
fit <- sem(model, data = dat, fixed.x = FALSE,
           se = "boot",
           bootstrap = 100)
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
#>   Standard errors                            Bootstrap
#>   Number of requested bootstrap draws              100
#>   Number of successful bootstrap draws             100
#> 
#> Regressions:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>   m ~                                                 
#>     x          (a)    0.569    0.325    1.749    0.080
#>   y ~                                                 
#>     m          (b)    0.219    0.146    1.495    0.135
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>    .m                 0.460    0.086    5.381    0.000
#>    .y                 0.570    0.110    5.178    0.000
#>     x                 0.078    0.012    6.782    0.000
#> 
#> Defined Parameters:
#>                    Estimate  Std.Err  z-value  P(>|z|)
#>     ab                0.125    0.125    0.997    0.319
#> 

fit <- store_boot(fit)
```
