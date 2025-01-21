##### Bootstrapping in R #####

# This script demonstrates:
# 1. Bootstrapping the slope of a regression line using manual sampling.
# 2. Bootstrapping using the `boot` package for automated resampling.

---
  
  ### Step 1: Install and Load Required Libraries ###
  
  # Install and load the `boot` package
  if (!requireNamespace("boot", quietly = TRUE)) {
    install.packages("boot")
  }
library(boot)

# Access documentation
help(boot)

---
  
  ### Part 1: Manual Bootstrapping ###
  
  #### Import Data
  cat("Please select a CSV file to load your dataset.\n")
datum <- read.csv(file.choose())
head(datum)  # Preview the dataset

#### Run Initial Regression
cat("\nRunning initial regression...\n")
results <- lm(Y ~ X, data = datum)  # Linear regression
summary(results)                    # Regression summary
cat("Slope Estimate:", coef(results)[2], "\n")  # Extract slope

#### Create a Tracker for Bootstrapped Slopes
cat("\nInitializing slope tracker for bootstrapped slopes...\n")
SlopeTracker <- rep(0, 1000)  # Vector to store bootstrapped slope estimates
sample_size <- length(datum$X)  # Original dataset size

#### Perform One Iteration of Bootstrapping
cat("\nPerforming a single bootstrap iteration...\n")
set.seed(123)  # Ensure reproducibility
Test <- sample(1:sample_size, sample_size, replace = TRUE)  # Resample indices with replacement
datumBoot <- datum[Test, ]  # Create bootstrapped dataset
resultsTest <- lm(Y ~ X, data = datumBoot)  # Run regression on bootstrapped data
cat("Bootstrapped Slope:", coef(resultsTest)[2], "\n")

#### Perform 1000 Bootstrapping Iterations
cat("\nPerforming 1000 bootstrapping iterations...\n")
for (i in 1:1000) {
  Test <- sample(1:sample_size, sample_size, replace = TRUE)  # Resample indices
  datumBoot <- datum[Test, ]  # Create bootstrapped dataset
  resultsTest <- lm(Y ~ X, data = datumBoot)  # Run regression
  SlopeTracker[i] <- coef(resultsTest)[2]  # Store slope
}

#### Sort Slope Tracker and Calculate Confidence Intervals
cat("\nCalculating confidence intervals from bootstrapped slopes...\n")
SlopeTracker <- sort(SlopeTracker)
LowerCI <- SlopeTracker[25]  # 2.5th percentile (lower CI)
UpperCI <- SlopeTracker[975] # 97.5th percentile (upper CI)
cat("Bootstrapped 95% CI for Slope: [", LowerCI, ",", UpperCI, "]\n")

#### Compare to Parametric Confidence Interval
parametric_CI <- confint(results)
cat("Parametric 95% CI for Slope:\n")
print(parametric_CI)

---
  
  ### Part 2: Automated Bootstrapping Using `boot` ###
  
  #### Define Custom Bootstrapping Function
  cat("\nDefining custom bootstrapping function...\n")
lmFunc <- function(bootData, indices) {
  results <- lm(Y ~ X, data = bootData[indices, ])  # Run regression on bootstrapped sample
  beta <- coef(results)[2]  # Extract slope
  return(beta)
}

#### Run Bootstrapping with `boot`
cat("\nRunning bootstrapping with the `boot` package...\n")
set.seed(123)  # Ensure reproducibility
boot_results <- boot(data = datum, statistic = lmFunc, R = 1000)  # Perform 1000 bootstraps
print(boot_results)  # View bootstrapping results

#### Calculate Confidence Intervals
cat("\nCalculating bootstrapped confidence intervals...\n")
boot_CI <- boot.ci(boot_results, type = c("basic", "perc", "bca"))
print(boot_CI)

#### Compare to Parametric Results
cat("\nComparing bootstrapped results to parametric results...\n")
print(summary(results))
print(parametric_CI)

---
  
  ### Notes ###
  
  # - Replace placeholder variable names (e.g., `Y`, `X`) with the actual column names in your dataset.
  # - Use `set.seed()` to ensure reproducibility of bootstrapped results.
  # - Bootstrapping is a non-parametric method that is particularly useful when:
  #   - Data does not meet parametric assumptions.
  #   - The sample size is small.
  # - Confidence intervals from bootstrapping are often more robust than parametric intervals for non-normal data.