##### Basic Linear Regression in R #####

# This script demonstrates:
# 1. Loading data
# 2. Exploring the dataset
# 3. Creating a scatterplot
# 4. Running a linear regression
# 5. Interpreting regression results
# 6. Generating confidence intervals
# 7. Adding a regression line to the plot

### Step 1: Import Data ###

# Prompt user to select a CSV file and load it as a data frame
cat("Please select a CSV file to load your dataset.\n")
datum <- read.csv(file.choose())  # Opens a file dialog to select a CSV file

# Confirm successful data import
cat("Data successfully loaded. Here's a preview:\n")
head(datum, 10)                  # Display the first 10 rows of the dataset
cat("\nSummary statistics for the dataset:\n")
summary(datum)                   # Summary statistics for each column
cat("\nColumn names in the dataset:\n")
names(datum)                     # List all column names

### Step 2: Create a Scatterplot ###

# Scatterplot for visualizing the relationship between variables
# Replace 'Y' and 'X' with column names from your dataset
cat("\nGenerating scatterplot...\n")
plot(Biomass ~ Rainfall, data = datum,
     main = "Scatterplot of Biomass vs Rainfall",
     xlab = "Rainfall",
     ylab = "Biomass",
     pch = 19,           # Solid circles for points
     col = "blue")       # Points in blue

### Step 3: Run Linear Regression ###

# Perform linear regression
cat("\nRunning linear regression...\n")
results <- lm(Biomass ~ Rainfall, data = datum)

# Display regression summary
cat("\nRegression Summary:\n")
print(summary(results))

# Optional: Perform ANOVA on the regression model
cat("\nANOVA Table:\n")
print(anova(results))

# Extract regression coefficients
cat("\nRegression Coefficients:\n")
print(coef(results))

### Step 4: Generate Confidence Intervals ###

# Calculate and display confidence intervals for the regression coefficients
cat("\nConfidence Intervals for Coefficients:\n")
print(confint(results))

### Step 5: Add Regression Line to Scatterplot ###

# Add the regression line to the scatterplot
cat("\nAdding regression line to scatterplot...\n")
abline(results, col = "red", lwd = 2)  # Regression line in red, width = 2

### Step 6: Interpretation Tips ###

cat("\nInterpretation Tips:\n")
cat("1. Slope: Indicates how much Y changes for a one-unit increase in X.\n")
cat("2. Intercept: Value of Y when X is 0.\n")
cat("3. p-value: Tests whether the slope is significantly different from 0.\n")
cat("4. R-squared: Proportion of variability in Y explained by X.\n")

### Notes ###

# - Ensure your column names match those in your dataset.
# - Check for missing data before running the script.
# - Use informative labels and titles in your plots for better presentation.

### End of Script ###