##### Mixed Effects Models in R #####

# This script demonstrates:
# 1. Random effects models
# 2. Mixed-effects models
# 3. Comparing models with F-drop tests and likelihood methods
# 4. Handling repeated measures and autocorrelation

---
  
  ### Step 1: Import Required Libraries ###
  
  # Install and load necessary packages
  if (!requireNamespace("nlme", quietly = TRUE)) {
    install.packages("nlme")
  }
if (!requireNamespace("lme4", quietly = TRUE)) {
  install.packages("lme4")
}
library(nlme)
library(lme4)

---
  
  ### Step 2: Random Effects Models ###
  
  #### Import Data
  cat("Please select a CSV file to load your dataset.\n")
datum <- read.csv(file.choose())
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)

#### Create a Random Effects Model with `nlme`
cat("\nCreating random effects model using nlme...\n")
results <- lme(Abundance ~ 1, data = datum, random = ~1 | Year)
cat("\nSummary of Random Effects Model:\n")
print(summary(results))

#### Test Significance of Random Effects
cat("\nComparing model with and without random effects...\n")
results_lm <- lm(Abundance ~ 1, data = datum)  # No random effects
anova_results <- anova(results, results_lm)
cat("\nF-drop Test Results:\n")
print(anova_results)

#### Create a Random Effects Model with `lme4`
cat("\nCreating random effects model using lme4...\n")
results_lmer <- lmer(Abundance ~ 1 + (1 | Year), data = datum)
cat("\nSummary of Random Effects Model (lme4):\n")
print(summary(results_lmer))

---
  
  ### Step 3: Mixed-Effects Models ###
  
  #### Import Data
  cat("\nPlease select a CSV file to load your dataset for mixed-effects models...\n")
datum <- read.csv(file.choose())
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)

#### Mixed-Effects Model Without Random Effects
cat("\nRunning fixed-effects model without random effects...\n")
results_fixed <- lm(Biomass ~ Treatment, data = datum)
cat("\nSummary of Fixed Effects Model:\n")
print(summary(results_fixed))

#### Mixed-Effects Model With Random Effects
cat("\nRunning mixed-effects model with random effects for Field...\n")
results_random <- lme(Biomass ~ Treatment, data = datum, random = ~1 | Field)
cat("\nSummary of Mixed Effects Model:\n")
print(summary(results_random))

---
  
  ### Step 4: Random Slopes ###
  
  #### Import Data
  cat("\nPlease select a CSV file to load dataset for random slopes analysis...\n")
datum2 <- read.csv(file.choose())
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum2)

#### Model With Random Intercept
cat("\nRunning model with random intercept...\n")
results_intercept <- lme(Biomass ~ Treatment, data = datum2, random = ~1 | Field)
cat("\nSummary of Model With Random Intercept:\n")
print(summary(results_intercept))

#### Model With Random Slope
cat("\nRunning model with random slope...\n")
results_slope <- lme(Biomass ~ Treatment, data = datum2, random = ~Treatment | Field)
cat("\nSummary of Model With Random Slope:\n")
print(summary(results_slope))

#### Compare Models With F-drop Test
cat("\nComparing models with random intercept and random slope...\n")
results_null <- lme(Biomass ~ 1, data = datum2, random = ~1 | Field)
anova_results <- anova(results_null, results_slope)
cat("\nF-drop Test Results:\n")
print(anova_results)

---
  
  ### Step 5: Model Comparison With REML and ML ###
  
  cat("\nComparing models using REML and ML...\n")

# REML (default for coefficient estimation)
results_reml <- lme(Biomass ~ Treatment, data = datum2, random = ~1 | Field)

# ML (for comparing models with different fixed effects)
results_ml <- lme(Biomass ~ Treatment, data = datum2, random = ~1 | Field, method = "ML")
results_null_ml <- lme(Biomass ~ 1, data = datum2, random = ~1 | Field, method = "ML")

anova_ml <- anova(results_ml, results_null_ml)
cat("\nML-Based Model Comparison:\n")
print(anova_ml)

---
  
  ### Step 6: Repeated Measures and Autocorrelation ###
  
  #### Import Data
  cat("\nPlease select a CSV file to load dataset for repeated measures...\n")
datum <- read.csv(file.choose())
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)

#### Randomized Block Analysis
cat("\nRunning randomized block analysis...\n")
results_repeated <- lme(Pollution ~ Distance, data = datum, random = ~1 | River)
cat("\nSummary of Repeated Measures Model:\n")
print(summary(results_repeated))

#### Autocorrelation Structures
cat("\nAdding autocorrelation structure (AR1)...\n")
results_ar1 <- lme(Pollution ~ Distance, data = datum, random = ~1 | River, correlation = corAR1())
cat("\nSummary of Model With AR1 Structure:\n")
print(summary(results_ar1))

cat("\nAdding autocorrelation structure (MA1)...\n")
results_ma1 <- lme(Pollution ~ Distance, data = datum, random = ~1 | River, correlation = corARMA(p = 0, q = 1))
cat("\nSummary of Model With MA1 Structure:\n")
print(summary(results_ma1))

---
  
  ### Notes ###
  
  # - Replace variable names (e.g., Abundance, Biomass, Treatment) with column names from your dataset.
  # - Use `lme` or `lmer` for mixed-effects models, depending on the package.
  # - Choose REML for coefficient estimation and ML for fixed-effects model comparison.
  # - Test for autocorrelation in repeated measures to ensure accurate results.
  
  ### End of Script ###
  