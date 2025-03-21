skip("To be run in an interactive mode")

library(testthat)
library(semboottools)

test_that("hist_qq_boot", {

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
                                        data = Data,
                                        se = "boot",
                                        bootstrap = 100,
                                        iseed = 1234)))
suppressWarnings(system.time(fitgp <- sem(modelgp,
                                          data = Data,
                                          se = "boot",
                                          group = "GP",
                                          bootstrap = 100,
                                          iseed = 1234)))

fit_boot <- store_boot(fit)
fitgp_boot <- store_boot(fitgp)

hist_qq_boot(fit_boot, "ab", standardized = TRUE)
hist_qq_boot(fit_boot, "ab", standardized = FALSE)
hist_qq_boot(fit_boot, "c", standardized = TRUE)
hist_qq_boot(fit_boot, "c", standardized = FALSE)
hist_qq_boot(fit_boot, "b", standardized = TRUE)
hist_qq_boot(fit_boot, "b", standardized = FALSE)
hist_qq_boot(fit_boot, "ab", standardized = TRUE, hist_linewidth = .1)

hist_qq_boot(fitgp_boot, "ab1", standardized = TRUE)
hist_qq_boot(fitgp_boot, "ab2", standardized = FALSE)
hist_qq_boot(fitgp_boot, "c1", standardized = TRUE)
hist_qq_boot(fitgp_boot, "c2", standardized = FALSE)
hist_qq_boot(fitgp_boot, "b2", standardized = TRUE)
hist_qq_boot(fitgp_boot, "b1", standardized = FALSE)

expect_error(hist_qq_boot(fit_boot, "X~~X", standardized = TRUE))
expect_error(hist_qq_boot(fit_boot, "X~~X", standardized = FALSE))
expect_error(hist_qq_boot(fitgp_boot, "X~~X", standardized = TRUE))
expect_error(hist_qq_boot(fitgp_boot, "X~~X", standardized = FALSE))

# Support standardizedSolution_boot()

suppressWarnings(std <- standardizedSolution_boot(fit))
suppressWarnings(stdgp <- standardizedSolution_boot(fitgp))

# Examine interactively

hist_qq_boot(std, "ab")
hist_qq_boot(fit_boot, "ab", standardized = TRUE)

hist_qq_boot(std, "total")
hist_qq_boot(fit_boot, "total", standardized = TRUE)

hist_qq_boot(stdgp, "M~~M.g2")
hist_qq_boot(fitgp_boot, "M~~M.g2", standardized = TRUE)

hist_qq_boot(stdgp, "M~~M")
hist_qq_boot(fitgp_boot, "M~~M", standardized = TRUE)

})