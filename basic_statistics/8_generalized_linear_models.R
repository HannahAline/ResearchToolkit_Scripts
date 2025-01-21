##### Generalized Linear Models (GLMs) in R #####

# This script demonstrates:
# 1. Poisson regression for count data
# 2. Logistic regression for binomial data
# 3. Interpreting GLM coefficients using exponentiation
# 4. Scaling variables for meaningful interpretations
# 5. Making predictions with GLMs

---
  
  ### Step 1: Import Data ###
  
  # Prompt user to select a CSV file
  cat("Please select a CSV file to load your dataset.\n")
datum <- read.csv(file.choose())

# Confirm successful data import
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)

---
  
  ### Part 1: Poisson Regression ###
  
  #### Example: Effects of Age and Birth Location on Litter Size
  # Litter size is count data, typically modeled with Poisson regression
  
  # Run Poisson regression
  cat("\nRunning Poisson regression...\n")
results_poisson <- glm(LitterSize ~ Age + BirthLoc, data = datum, family = poisson)
cat("\nSummary of Poisson Regression:\n")
print(summary(results_poisson))

#### Interpreting Coefficients
cat("\nInterpreting Poisson regression coefficients...\n")

# Effect of Birth Location
birthloc_effect <- exp(1.70471)  # Example coefficient for BirthLoc
cat("Wild-born wolves have", round(birthloc_effect, 2), "times as many pups as captive-born wolves.\n")

# Effect of Age
age_effect <- exp(0.10908)  # Example coefficient for Age
cat("For each 1-year increase in age, wolves have", round(age_effect, 2), "times as many pups.\n")

# Predicting Litter Size
cat("\nPrediction Example:\n")
predicted_pups <- exp(-0.21178 + 1.70471 + 0.10908 * 5)  # Prediction for a 5-year-old wild-born wolf
cat("A 5-year-old wild-born wolf is expected to have", round(predicted_pups, 2), "pups on average.\n")

---
  
  ### Part 2: Logistic Regression ###
  
  #### Example: Effects of Age and Birth Location on Survival
  # Survival is binary data (e.g., survived/died), typically modeled with logistic regression
  
  # Run logistic regression
  cat("\nRunning logistic regression...\n")
results_logistic <- glm(Mortality ~ Age + BirthLoc, data = datum, family = binomial)
cat("\nSummary of Logistic Regression:\n")
print(summary(results_logistic))

#### Interpreting Coefficients
cat("\nInterpreting logistic regression coefficients...\n")

# Effect of Birth Location
birthloc_odds <- exp(2.6016)  # Example coefficient for BirthLoc
cat("Wild-born wolves are", round(birthloc_odds, 2), "times as likely to die as captive-born wolves.\n")

# Effect of Age
age_odds <- exp(0.5354)  # Example coefficient for Age
cat("For each 1-year increase in age, wolves are", round(age_odds, 2), "times as likely to die.\n")

# Predicting Survival
cat("\nPrediction Example:\n")
predicted_mortality <- exp(-2.8894 + 2.6016 + 0.5354 * 5) / 
  (1 + exp(-2.8894 + 2.6016 + 0.5354 * 5))  # Probability of mortality for a 5-year-old wild-born wolf
cat("A 5-year-old wild-born wolf has an estimated mortality rate of", 
    round(predicted_mortality * 100, 2), "%.\n")

---
  
  ### Part 3: Adding Additional Predictors ###
  
  #### Example: Effects of Age, Birth Location, and Body Condition on Litter Size
  # Body condition is included as an additional predictor
  
  # Run Poisson regression
  cat("\nRunning Poisson regression with additional predictors...\n")
results_extended <- glm(LitterSize ~ Age + BirthLoc + BodyCond, data = datum, family = poisson)
cat("\nSummary of Extended Poisson Regression:\n")
print(summary(results_extended))

#### Interpreting Coefficients
cat("\nInterpreting extended model coefficients...\n")

# Effect of Age
age_effect <- exp(-0.20223)
cat("For each 1-year increase in age, wolves have", round(age_effect, 2), "times as many pups.\n")

# Effect of Body Condition (Scaled)
bodycond_effect <- exp(2.22882 * 0.1)  # Scaled for a 10% increase in body fat
cat("For each 10% increase in body fat, wolves have", round(bodycond_effect, 2), "times as many pups.\n")

# Prediction Example
body_fat_range_effect <- exp(2.22882 * (0.5 - 0.1))  # Difference between 0.1 and 0.5 body fat
cat("The fattest wolves have", round(body_fat_range_effect, 2), 
    "times as many pups as the leanest wolves.\n")

---
  
  ### Notes ###
  
  # - Replace variable names (e.g., LitterSize, Age, BirthLoc) with those in your dataset.
  # - Use `exp()` to interpret GLM coefficients for Poisson and logistic regressions.
  # - Scale predictors (e.g., body condition) to make effect sizes meaningful.
  # - GLMs require specifying the `family` argument to indicate the error structure:
  #   - `poisson`: Count data
  #   - `binomial`: Binary data
  # - Predictions for logistic regressions should be converted to probabilities:
  #   - Probability = exp(linear_predictor) / (1 + exp(linear_predictor))

---
  
  ### Suggested Improvements ###
  1. **Automate Scaling**:
  - Automatically detect ranges of variables like body condition for scaling.
2. **Visualization**:
  - Add plots for predicted probabilities or counts based on fitted GLMs.
- Use packages like `ggplot2` for better visualizations.

---
  
  ### Suggested File Name ###
  **`generalized_linear_models.R`**
  
  ---
  
  ### Next Steps ###
  1. **Save the Script**:
  - Save it in your `basic_statistics` folder.

2. **Push to GitHub**:
  ```bash
git add basic_statistics/generalized_linear_models.R
git commit -m "Add GLM script for Poisson and logistic regression"
git push origin main
