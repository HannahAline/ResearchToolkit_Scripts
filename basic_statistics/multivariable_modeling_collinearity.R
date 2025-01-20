##### Multivariable Modeling and Collinearity in R #####

# This script demonstrates:
# 1. Multivariable linear modeling
# 2. Detecting collinearity using Variance Inflation Factors (VIF)
# 3. Performing advanced model comparisons and diagnostics
# 4. Visualizing model results with ggplot2 and emmeans

---
  
  ### Step 1: Import Data ###
  
  # Prompt user to select a CSV file
  cat("Please select a CSV file to load your dataset.\n")
datum <- read.csv(file.choose())

# Confirm successful data import
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)

---
  
  ### Step 2: Visualize Relationships ###
  
  # Scatterplots for individual relationships
  cat("\nGenerating scatterplots...\n")
plot(Size ~ Sex, data = datum,
     main = "Size vs. Sex",
     xlab = "Sex (Categorical Variable)",
     ylab = "Size",
     col = "blue")

plot(Size ~ Age, data = datum,
     main = "Size vs. Age",
     xlab = "Age (Continuous Variable)",
     ylab = "Size",
     col = "green")

---
  
  ### Step 3: Single-Variable Linear Models ###
  
  # Analyze the relationship between Size and Age
  cat("\nRunning single-variable regression for Age...\n")
results_age <- lm(Size ~ Age, data = datum)
cat("\nSummary of Age Model:\n")
print(summary(results_age))

# Analyze the relationship between Size and Sex
cat("\nRunning single-variable regression for Sex...\n")
results_sex <- lm(Size ~ Sex, data = datum)
cat("\nSummary of Sex Model:\n")
print(summary(results_sex))

---
  
  ### Step 4: Multivariable Linear Model ###
  
  # Include both Age and Sex in the model
  cat("\nRunning multivariable regression for Age and Sex...\n")
results_multivar <- lm(Size ~ Age + Sex, data = datum)
cat("\nSummary of Multivariable Model:\n")
print(summary(results_multivar))

---
  
  ### Step 5: Check for Collinearity Using VIF ###
  
  # Run a regression with multiple predictors
  cat("\nRunning multivariable regression with additional predictors...\n")
results_vif <- lm(Size ~ Age + Sex + MotherSize + FatherSize, data = datum)
cat("\nSummary of Model:\n")
print(summary(results_vif))

# Calculate Variance Inflation Factors (VIF)
cat("\nCalculating Variance Inflation Factors (VIF)...\n")
library(car)  # Load the car package
vif_results <- vif(results_vif)
print(vif_results)

# Interpretation:
# - High VIF (>10) indicates strong collinearity.
# - VIF = 1/(1 - R^2), where R^2 is from regressing a predictor on all other predictors.

---
  
  ### Step 6: Correlation Matrix for Continuous Variables ###
  
  # Generate a correlation matrix for continuous variables
  cat("\nCalculating correlation matrix...\n")
datum_cont <- data.frame(Age = datum$Age,
                         MotherSize = datum$MotherSize,
                         FatherSize = datum$FatherSize)
cat("\nCorrelation Matrix (R):\n")
print(cor(datum_cont))
cat("\nSquared Correlation Matrix (R^2):\n")
print(cor(datum_cont)^2)

---
  
  ### Step 7: Advanced Model Comparisons ###
  
  #### F-Drop Test ####
# Compare models to test the significance of a variable
cat("\nPerforming F-drop test for the significance of predictors...\n")
results_full <- lm(Size ~ Age + Sex + MotherSize + FatherSize, data = datum)
results_reduced <- lm(Size ~ Age + Sex, data = datum)
anova_results <- anova(results_reduced, results_full)
cat("\nF-drop Test Results:\n")
print(anova_results)

#### Changing Reference Category ####
cat("\nChanging reference category for categorical variable...\n")
results_relevel <- lm(Size ~ relevel(Sex, ref = "Male") + Age, data = datum)
cat("\nSummary of Model with Changed Reference:\n")
print(summary(results_relevel))

---
  
  ### Step 8: Post-Hoc Tests with emmeans ###
  
  # Perform post-hoc comparisons with emmeans
  cat("\nRunning post-hoc comparisons using emmeans...\n")
library(emmeans)
emmeans_results <- emmeans(results_multivar, pairwise ~ Sex)
cat("\nPairwise Comparisons:\n")
print(emmeans_results)

# Confidence intervals for post-hoc comparisons
cat("\nConfidence Intervals for Pairwise Comparisons:\n")
print(confint(emmeans_results))

---
  
  ### Step 9: Visualize Adjusted Means ###
  
  # Create a plot of adjusted means using ggplot2
  cat("\nVisualizing adjusted means with ggplot2...\n")
emmeans_data <- as.data.frame(emmeans_results$emmeans)
library(ggplot2)
ggplot(emmeans_data, aes(x = Sex, y = emmean, ymin = lower.CL, ymax = upper.CL)) +
  geom_col(fill = "skyblue", color = "black") +
  geom_errorbar(width = 0.3) +
  labs(x = "Sex", y = "Adjusted Mean Size",
       title = "Adjusted Means with 95% Confidence Intervals") +
  theme_classic()

---
  
  ### Notes ###
  
  # - Replace variable names (e.g., Size, Age, Sex) with actual column names from your dataset.
  # - Address collinearity by removing or combining highly correlated variables.
  # - Use VIF to detect collinearity but rely on theory or domain knowledge for model selection.
  
  ### End of Script ###
  