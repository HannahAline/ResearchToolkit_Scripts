# Install required packages (only run once)
install.packages(c("mlr3", "mlr3learners", "mlr3verse", "ggplot2"))

#### -- Classification -- ####

## Step 1: Load packages
# Load necessary mlr3 packages
library(mlr3)
library(mlr3learners)
library(mlr3verse)

## Step 2: Load and prep data
# Load dataset
library(palmerpenguins)

# Select relevant features and remove rows with missing values
data = na.omit(penguins[, c("species", "bill_length_mm", "bill_depth_mm", 
                            "flipper_length_mm", "body_mass_g")])

# Inspect class balance
table(data$species)

## Step 3: Splitting training and testing subsets
# Split data into training and testing sets (80/20 split)
set.seed(123)
train_ids = sample(seq_len(nrow(data)), size = 0.8 * nrow(data))
train_data = data[train_ids, ]
test_data = data[-train_ids, ]

## Step 4: Define the task
# Create classification task using training data
task_penguins = TaskClassif$new(
  id = "penguins", 
  backend = train_data, 
  target = "species"
)

## Step 5: Set up learner, resampling, and measure
# Define learner: decision tree (rpart)
learner = lrn("classif.rpart")

# Set up 5-fold cross-validation
resampling = rsmp("cv", folds = 5)

# Use accuracy as performance metric
measure = msr("classif.acc")

## Step 6: Run and evaluate
# Resample to estimate model performance
rr_rpart = resample(task_penguins, learner, resampling)

# Aggregate accuracy across folds
rr_rpart$aggregate(measure)

## Let’s swap in a Random Forest learner!
# Define random forest learner with feature importance enabled
learner_rf = lrn("classif.ranger", importance = "impurity")

# Resample random forest for comparison
rr_rf = resample(task_penguins, learner_rf, resampling)

## Compare learner accuracy
# Compare model accuracies
rr_rpart$aggregate(msr("classif.acc"))
rr_rf$aggregate(msr("classif.acc"))

## Train model with best performing learner
# Train final random forest model on full training data
learner_rf$train(task_penguins)

## Test your ML model!
# Predict on unseen test data
prediction = learner_rf$predict_newdata(newdata = test_data)

## Diagnosing Your Model: Start with Accuracy
# Evaluate accuracy on test set
prediction$score(msr("classif.acc"))

## Confusion Matrix
# Confusion matrix for detailed diagnostics
prediction$confusion

## Class-Level Metrics
# Calculate precision, recall, and F1 for each class
cm = prediction$confusion
precision = diag(cm)/colSums(cm)   # TP / (TP + FP)
recall    = diag(cm)/rowSums(cm)   # TP / (TP + FN)
f1        = 2*precision*recall/(precision+recall)
data.frame(class = rownames(cm), precision, recall, f1)

## Extracting & Plotting Feature Importance
# Extract and plot feature importance
importance = learner_rf$importance()
importance_df = data.frame(feature = names(importance), importance = importance)

library(ggplot2)
ggplot(importance_df, aes(x = reorder(feature, importance), y = importance)) +
  geom_col() + 
  coord_flip() +
  labs(x = "Feature", y = "Importance") +
  theme_minimal()


#### -- Regression -- ####

## Step 1: Re-load and prep data
# Subset for regression task (predicting body mass)
data = na.omit(penguins[, c("body_mass_g", "bill_length_mm", "bill_depth_mm", 
                            "flipper_length_mm")])

## Step 2: Splitting training and testing subsets
# Train/test split
set.seed(124)
train_ids = sample(seq_len(nrow(data)), size = 0.8 * nrow(data))
train_data = data[train_ids, ]
test_data = data[-train_ids, ]

## Step 3: Define the task
# Create regression task
task_reg = TaskRegr$new(
  id = "mass", 
  backend = train_data, 
  target = "body_mass_g"
)

## Step 4: Set up learner
# Define KNN regression learner
learner_reg = lrn("regr.kknn")

## Step 5: Train and test the model
# Train model
learner_reg$train(task_reg)

# Predict on test data
prediction = learner_reg$predict_newdata(newdata = test_data)

## Evaluate the model
# Calculate R-squared performance
rsq = msr("regr.rsq")
performance = prediction$score(rsq)

# Scatterplot of predicted vs actual values
plot(prediction$truth, prediction$response, xlab = "True", ylab = "Predicted")
abline(0, 1, col = "red")  # Ideal 1:1 line



