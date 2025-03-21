% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parameterEstimates_boot.R
\name{parameterEstimates_boot}
\alias{parameterEstimates_boot}
\title{Bootstrap CIs for Parameter
Estimates}
\usage{
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
}
\arguments{
\item{object}{A 'lavaan'-class
object, fitted with 'se = "boot"'.}

\item{level}{The level of confidence
of the confidence intervals. Default
is .95.}

\item{boot_org_ratio}{The ratio of
(a) the distance of the bootstrap
confidence limit from the point
estimate to (b) the distance of the
original confidence limit in
\code{object} from the point
estimate. Default is \code{FALSE}.}

\item{boot_ci_type}{The type of the
bootstrapping confidence intervals.
Support percentile confidence intervals
(\code{"perc"}, the default) and
bias-corrected confidence intervals
(\code{"bc"} or \code{"bca.simple"}).}

\item{save_boot_est}{Whether the
bootstrap estimates of the
parameter estimates are saved. If
saved, the bootstrap estimates
of the free parameters will be stored
in the attribute \code{boot_est_ustd},
while the bootstrap estimates of
user-defined parameters, if any,
will be stored in the attribute
\code{boot_def}. Default is
\code{TRUE}.}

\item{boot_pvalue}{Whether asymmetric
bootstrap \emph{p}-values are computed.
Default is \code{TRUE}.}

\item{boot_pvalue_min_size}{Integer.
The asymmetric bootstrap \emph{p}-values
will be computed only if the number
of valid bootstrap estimates is at
least this value. Otherwise, \code{NA}
will be returned. If the number of
valid bootstrap samples is less than
this value, then \code{boot_pvalue} will
be set to \code{FALSE}.}

\item{standardized}{The type of standardized
estimates. The same argument of
\code{\link[lavaan:parameterEstimates]{lavaan::parameterEstimates()}},
and support all values supported by
\code{\link[lavaan:parameterEstimates]{lavaan::parameterEstimates()}}. It is
recommended to use \code{\link[=standardizedSolution_boot]{standardizedSolution_boot()}}
or \code{\link[lavaan:standardizedSolution]{lavaan::standardizedSolution()}}
because this function only report
the point estimates of the standardized
solution, without standard
errors or confidence intervals.}

\item{...}{Other arguments to be
passed to
\code{\link[lavaan:parameterEstimates]{lavaan::parameterEstimates()}}.}
}
\value{
The output of
\code{\link[lavaan:parameterEstimates]{lavaan::parameterEstimates()}},
with bootstrap confidence intervals
appended to the right, with class
set to \code{sbt_ustd_boot}. It has
a print method
(\code{\link[=print.sbt_ustd_boot]{print.sbt_ustd_boot()}}) that
can be used to print the parameter
estimates in a format similar to
that of the printout of
the \code{\link[=summary]{summary()}} of a \link[lavaan:lavaan-class]{lavaan::lavaan} object.
}
\description{
Functions for forming
bootstrap confidence intervals
for the parameter estimates.
}
\details{
\code{\link[=parameterEstimates_boot]{parameterEstimates_boot()}}
receives a
\link[lavaan:lavaan-class]{lavaan::lavaan} object and
form bootstrap confidence intervals
for the parameter estimates.

The function \code{\link[=store_boot]{store_boot()}} should
be called first to
compute and store bootstrap estimates.
This function will then retrieve them.
\subsection{Bootstrap Confidence Intervals}{

It supports percentile and
bias-corrected bootstrap confidence
intervals.
}

\subsection{Bootstrap Standard Errors}{

The standard errors are the
standard deviation of the bootstrap
estimates.
}

\subsection{Bootstrap Asymmetric \emph{p}-Values}{

If percentile bootstrap confidence
interval is requested, asymmetric
bootstrap \emph{p}-values are also
computed, using the method presented
in Asparouhov and Muthén (2021).
}
}
\examples{

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
fit <- store_boot(fit,
                  do_bootstrapping = TRUE,
                  R = 100,
                  iseed = 1234)
est <- parameterEstimates_boot(fit)
est

}
\references{
Asparouhov, A., & Muthén, B. (2021). Bootstrap p-value computation.
Retrieved from https://www.statmodel.com/download/FAQ-Bootstrap\%20-\%20Pvalue.pdf
}
\seealso{
\code{\link[lavaan:parameterEstimates]{lavaan::parameterEstimates()}}, \code{\link[=store_boot]{store_boot()}}
}
\author{
Shu Fai Cheung
\url{https://orcid.org/0000-0002-9871-9448}.
}
