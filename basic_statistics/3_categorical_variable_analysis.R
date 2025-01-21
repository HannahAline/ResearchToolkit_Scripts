##### Analyzing Categorical Variables in R #####

# This script demonstrates:
# 1. Converting variables to categorical (factors)
# 2. Visualizing data with box plots
# 3. Running t-tests, ANOVA, and regression with categorical variables
# 4. Conducting post-hoc tests and advanced analyses

---
  
  ### Step 1: Import Data ###
  
  # Prompt user to select a CSV file
  cat("Please select a CSV file to load your dataset.\n")
datum <- read.csv(file.choose())  # Opens a file dialog to select a CSV file

# Confirm successful data import
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)  # Display the first 6 rows

---
  
  ### Step 2: Convert Variables to Categorical ###
  
  # Convert 'Sex' to a factor (categorical variable)
  cat("\nConverting 'Sex' to a factor...\n")
datum$Sex <- as.factor(datum$Sex)

# Verify the factor levels
cat("\nLevels of 'Sex':\n")
print(levels(datum$Sex))  # Prints the categories in 'Sex'

---
  
  ### Step 3: Visualize Data ###
  
  # Plot relationship between 'Sex' and 'Mass'
  cat("\nGenerating box plot of Mass by Sex...\n")
plot(Mass ~ Sex, data = datum,
     main = "Mass by Sex",
     xlab = "Sex (Categorical Variable)",
     ylab = "Mass (Continuous Variable)",
     col = c("blue", "pink"),  # Custom colors for box plots
     border = "black")         # Black border for boxes

---
  
  ### Step 4: Perform a t-test ###
  
  # Run a t-test comparing Mass between sexes
  cat("\nRunning t-test...\n")
results <- t.test(Mass ~ Sex, data = datum, var.equal = TRUE)  # Assumes equal variance
print(results)  # Display t-test results

# Note:
# - `var.equal = TRUE` ensures homoscedasticity (equal variance) assumption for comparison with regression.

---
  
  ### Step 5: Regression with Categorical Variables ###
  
  # Run regression using 'Sex' as a categorical variable
  cat("\nRunning regression with Sex as a factor...\n")
resultslm <- lm(Mass ~ Sex, data = datum)
cat("\nRegression Summary:\n")
print(summary(resultslm))  # Display regression results

# Confidence intervals for regression coefficients
cat("\nConfidence Intervals:\n")
print(confint(resultslm))

---
  
  ### Step 6: ANOVA ###
  
  # Run an ANOVA to evaluate the effect of 'Sex' on 'Mass'
  cat("\nRunning ANOVA...\n")
results_aov <- aov(Mass ~ Sex, data = datum)
cat("\nANOVA Summary:\n")
print(summary(results_aov))

---
  
  ### Step 7: Post-hoc Tests ###
  
  # Conduct a Tukey's post-hoc test if ANOVA is significant
  cat("\nRunning Tukey's Post-hoc Test...\n")
if ("TukeyHSD" %in% rownames(installed.packages()) == FALSE) {
  install.packages("TukeyHSD")
}
library(stats)  # Load TukeyHSD if not already installed
print(TukeyHSD(results_aov))  # Display pairwise comparisons

---
  
  ### Advanced Analysis ###
  
  #### Dummy Coding ####
# Regression using dummy coded variables
cat("\nRunning regression with dummy coded variables...\n")
datum$Male <- ifelse(datum$Sex == "Male", 1, 0)  # Dummy code for 'Male'
results_dum <- lm(Mass ~ Male, data = datum)
cat("\nRegression Summary (Dummy Coding):\n")
print(summary(results_dum))
cat("\nConfidence Intervals (Dummy Coding):\n")
print(confint(results_dum))

#### Changing Reference Category ####
cat("\nChanging reference category...\n")
results_relevel <- lm(Mass ~ relevel(Sex, ref = "Female"), data = datum)
cat("\nRegression Summary (Releveled Reference):\n")
print(summary(results_relevel))

#### F-drop Test ####
cat("\nConducting F-drop test...\n")
results_full <- lm(Mass ~ Sex + OtherVariable, data = datum)
results_reduced <- lm(Mass ~ Sex, data = datum)
cat("\nF-drop Test Results:\n")
print(anova(results_reduced, results_full))  # Compare two models

---
  
  ### Notes ###
  
  # - Replace 'Sex', 'Mass', and other column names with those in your dataset.
  # - Check for missing data or outliers before running analyses.
  # - Post-hoc tests are only meaningful when ANOVA indicates significant differences.
  
  ### End of Script ###
  