##### Assumptions of Regression #####

# This script helps you:
# 1. Test the assumptions of linear regression
# 2. Diagnose issues like non-linearity, heteroscedasticity, non-normality, and autocorrelation
# 3. Interpret residuals and plots for better model evaluation

### Step 1: Import Data ###

# Prompt user to select a CSV file and load it into a data frame
cat("Please select a CSV file to load your dataset.\n")
datum <- read.csv(file.choose())  # Opens a file dialog to select a CSV file

# Confirm successful data import
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)                      # Display the first 6 rows
cat("\nSummary statistics for the dataset:\n")
summary(datum)                   # Provides summary statistics for all columns

### Step 2: Run a Linear Regression ###

# Replace 'Y' and 'X' with the column names for your dependent and independent variables
cat("\nRunning linear regression...\n")
results <- lm(Y ~ X, data = datum)  # Perform the regression
cat("\nRegression Summary:\n")
print(summary(results))            # Print regression results

# Note: The tests below require this regression (`results`) to be run first.

---
  
  ### Step 3: Test Assumptions ###
  
  #### 1. **Scatterplot: Visual Check of Assumptions**
  cat("\nGenerating scatterplot...\n")
plot(Y ~ X, data = datum,
     main = "Scatterplot of Y vs. X with Regression Line",
     xlab = "X (Independent Variable)",
     ylab = "Y (Dependent Variable)",
     pch = 19,          # Solid circle points
     col = "blue")      # Points in blue
abline(results, col = "red", lwd = 2)  # Add regression line in red

# Interpretation:
# - Non-linear relationship: Groups of points above/below the line.
# - Heteroscedasticity: Variance of errors increases/decreases with X.
# - Non-normality: Skewed errors above/below the line.
# - Autocorrelation: Points follow a pattern along the line.

---
  
  #### 2. **Residuals Plot**
  cat("\nPlotting residuals...\n")
residuals_data <- residuals(results)  # Extract residuals
plot(residuals_data ~ datum$X,
     main = "Residuals vs. X",
     xlab = "X (Independent Variable)",
     ylab = "Residuals",
     pch = 19, col = "blue")
abline(h = 0, col = "red", lwd = 2)  # Add horizontal line at 0

# Interpretation:
# - Non-linear relationship: Groups of residuals above/below the line.
# - Heteroscedasticity: Variance of residuals changes with X.
# - Non-normality: Skewed residuals above/below the line.
# - Autocorrelation: Residuals follow a pattern.

---
  
  #### 3. **Histogram of Residuals**
  cat("\nGenerating histogram of residuals...\n")
hist(residuals_data,
     main = "Histogram of Residuals",
     xlab = "Residuals",
     breaks = 10,  # Adjust number of bins
     col = "gray", border = "black")

# Interpretation:
# - Non-normality: Histogram appears non-normal (e.g., skewed, multimodal).

---
  
  #### 4. **Autocorrelation Function (ACF)**
  cat("\nChecking for autocorrelation...\n")
acf_ordered_residuals <- residuals_data[order(datum$X)]  # Order residuals by X
acf(acf_ordered_residuals, main = "Autocorrelation of Residuals")

# Interpretation:
# - Significant autocorrelation: Lines at lags (e.g., x = 1, 2, 3) cross the dotted horizontal lines.
# - Note: Violations of non-linearity can mimic autocorrelation.

---
  
  ### Notes ###
  
  # - Ensure you replace 'Y' and 'X' with actual column names from your dataset.
  # - Check for missing data or outliers before running the regression.
  # - Address assumption violations:
  #   - Non-linearity: Transform X or Y (e.g., log, square root).
  #   - Heteroscedasticity: Use robust standard errors or weighted regression.
  #   - Non-normality: Consider transformations or robust regression.
  #   - Autocorrelation: Explore time series methods or lagged variables.
  
### End of Script ###