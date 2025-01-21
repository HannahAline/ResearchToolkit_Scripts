##### Model Building and Predictions in R #####

# This script demonstrates:
# 1. Generating predictions and prediction intervals
# 2. Performing AIC-based model selection with multi-model inference
# 3. Running standard and k-fold cross-validation

---
  
  ### Step 1: Import Data ###
  
  # Prompt user to select a CSV file
  cat("Please select a CSV file to load your dataset.\n")
datum <- read.csv(file.choose())

# Confirm successful data import
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)

---
  
  ### Part 1: Generating Predictions ###
  
  #### Run the Model
  cat("\nRunning linear regression model...\n")
results <- lm(Y ~ X, data = datum)  # Replace 'Y' and 'X' with your dataset's column names
cat("\nModel Summary:\n")
print(summary(results))

#### Generate Predictions
cat("\nGenerating predictions and prediction intervals...\n")

# Define X values for predictions
summary(datum)  # Check the range of 'X'
x <- seq(from = min(datum$X), to = max(datum$X), by = 0.1)  # Replace 'X' with your column name
NewX <- data.frame(X = x)  # Create a data frame for prediction

# Generate predictions
predictions <- predict(results, NewX, interval = "prediction")
predictions <- as.data.frame(predictions)
predictions$X <- NewX$X  # Add X values to the predictions

#### Plot Predictions
cat("\nPlotting predictions...\n")
plot(Y ~ X, data = datum, main = "Predictions and Intervals", xlab = "X", ylab = "Y")  # Replace 'Y' and 'X'
lines(fit ~ X, data = predictions, col = "blue", lwd = 2)  # Best-fit line
lines(lwr ~ X, data = predictions, col = "red", lty = 2)  # Lower prediction interval
lines(upr ~ X, data = predictions, col = "red", lty = 2)  # Upper prediction interval

---
  
  ### Part 2: AIC Multi-Model Analysis ###
  
  #### Install and Load the `MuMIn` Package
  if (!requireNamespace("MuMIn", quietly = TRUE)) {
    install.packages("MuMIn")
  }
library(MuMIn)

#### Run Global Model
cat("\nRunning global model for AIC analysis...\n")
results <- glm(Present ~ ., data = datum, family = binomial, na.action = na.fail)
cat("\nModel Summary:\n")
print(summary(results))

#### All-Subsets Analysis with Dredge
cat("\nPerforming all-subsets analysis using dredge...\n")
dd <- dredge(results)
cat("\nAIC Table:\n")
print(dd)

# Save results to a file (optional)
# write.table(dd, file = "results_aic_table.txt", sep = "\t")

#### Multi-Model Inference
cat("\nPerforming multi-model inference...\n")
model_avg <- model.avg(get.models(dd, subset = TRUE))  # Subset by AIC threshold
cat("\nSummary of Model Averaging:\n")
print(summary(model_avg))
cat("\nVariable Importance:\n")
print(importance(model_avg))

---
  
  ### Part 3: Cross-Validation ###
  
  #### Split Data for Cross-Validation
  cat("\nSplitting data into training and testing sets...\n")
set.seed(123)  # Ensure reproducibility
training_idx <- sample(1:nrow(datum), size = 0.75 * nrow(datum), replace = FALSE)
datum_train <- datum[training_idx, ]
datum_test <- datum[-training_idx, ]

#### Train the Model on the Training Dataset
cat("\nTraining the model on the training dataset...\n")
results_train <- lm(Size ~ Age + Sex + MotherSize, data = datum_train)
cat("\nModel Summary (Training Data):\n")
print(summary(results_train))

#### Test Predictive Ability on Testing Dataset
cat("\nTesting predictive ability on testing dataset...\n")
predictions_test <- predict(results_train, datum_test)
validation <- lm(predictions_test ~ datum_test$Size)  # Compare predictions to actual values
cat("\nValidation Results:\n")
print(summary(validation))

#### Visualize Predictions
cat("\nVisualizing predictions vs. actual values...\n")
plot(predictions_test ~ datum_test$Size, 
     main = "Predicted vs. Actual Values",
     xlab = "Actual Values",
     ylab = "Predicted Values")
abline(0, 1, col = "red", lwd = 2)  # 1:1 line for reference

---
  
  ### Part 4: K-Fold Cross-Validation ###
  
  #### Install and Load the `caret` Package
  if (!requireNamespace("caret", quietly = TRUE)) {
    install.packages("caret")
  }
library(caret)

#### Run K-Fold Cross-Validation
cat("\nPerforming k-fold cross-validation...\n")
fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 1)  # 10-fold CV

# Run cross-validation
cv_results <- train(Size ~ Age + Sex + MotherSize, data = datum, method = "lm", trControl = fit_control)

#### Check Results
cat("\nCross-Validation Results:\n")
print(cv_results$results)  # Summary of performance metrics (RMSE, R², MAE)
cat("\nResample Results (Fold-by-Fold):\n")
print(cv_results$resample)  # Results for each fold

---
  
  ### Notes ###
  
  # - Replace variable names (e.g., Size, Age, X, Y) with actual column names from your dataset.
  # - Use prediction intervals (`predict()`) for visualizing model uncertainty.
  # - For multi-model inference:
  # - Use `dredge()` to compare models with AIC.
  # - Use `model.avg()` for model averaging.
  # - Cross-validation evaluates predictive performance:
  # - Standard CV partitions data into training and testing sets.
  # - K-fold CV uses multiple iterations for robust performance metrics.