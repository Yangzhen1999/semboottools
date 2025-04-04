skip("To be run in an interactive mode")

library(testthat)
library(semboottools)

test_that("scatter_boot", {

# Example from https://lavaan.ugent.be/tutorial/mediation.html

library(lavaan)
set.seed(1234)
n <- 100
X <- runif(n) - .5
M <- 0.20 * X + rnorm(n)
Y <- 0.17 * M + rnorm(n)
GP <- sample(c("GpA", "GpB"), replace = TRUE)
Data <- data.frame(X = 10 * X, Y = Y, M = 20 * M, GP = GP)
model <- ' # direct effect
             Y ~ c*X
           # mediator
             M ~ a*X
             Y ~ b*M
           # indirect effect (a*b)
             ab := a*b
           # total effect
             total := c + (a*b)
         '
modelgp <- ' # direct effect
             Y ~ c(c1, c2)*X
           # mediator
             M ~ c(a1, a2)*X
             Y ~ c(b1, b2)*M
           # indirect effect (a*b)
             ab1 := a1*b1
             ab2 := a2*b2
           # total effect
             total1 := c1 + (a1*b1)
             total1 := c2 + (a2*b2)
         '
# One bootstrap replication failed. Kept intentionally.
suppressWarnings(system.time(fit <- sem(model,
                                        data = Data)))
suppressWarnings(system.time(fitgp <- sem(modelgp,
                                          data = Data,
                                          group = "GP")))

fit_boot <- store_boot(fit,
                       R = 50,
                       iseed = 1234)
fitgp_boot <- store_boot(fitgp,
                         R = 50,
                         iseed = 1234)

# Support standardizedSolution_boot()

suppressWarnings(ustd <- parameterEstimates_boot(fit_boot,
                                                 boot_pvalue_min_size = 20))
suppressWarnings(ustdgp <- parameterEstimates_boot(fitgp_boot,
                                                   boot_pvalue_min_size = 20))

# Examine interactively

scatter_boot(ustd, c("ab", "a", "b"))
scatter_boot(fit_boot, c("ab", "a", "b"), standardized = FALSE)

scatter_boot(ustd, c("c", "a", "b"))
scatter_boot(fit_boot, c("c", "a", "b"), standardized = FALSE)

scatter_boot(ustdgp, c("M~~M", "M~~M.g2"))
scatter_boot(fitgp_boot, c("M~~M", "M~~M.g2"), standardized = FALSE)

})