##### Multivariate Analyses in R #####

# This script covers:
# 1. Principal Components Analysis (PCA)
# 2. Factor Analysis
# 3. Discriminant Function Analysis (DFA)

---
  
  ### Step 1: Import Data ###
  cat("Please select a CSV file to load your dataset.\n")
datumFull <- read.csv(file.choose())
head(datumFull)  # Preview the dataset

---
  
  ### Part 1: Principal Components Analysis (PCA) ###
  
  #### Subset Data for PCA
  cat("\nSubsetting dataset for PCA...\n")
datum <- data.frame(Mass = datumFull$Mass, Body = datumFull$BodyLength)

#### Center and Scale Data
cat("\nCentering and scaling data...\n")
CentDatum <- data.frame(Mass = scale(datum$Mass, scale = FALSE), Body = scale(datum$Body, scale = FALSE))
ScaleDatum <- data.frame(Mass = scale(datum$Mass), Body = scale(datum$Body))

#### Analyze Data
cat("\nRunning PCA...\n")
results <- princomp(datum)  # PCA using unscaled data
summary(results)            # Variance explained by components
print(results$loadings)     # Contribution of variables to components

#### Visualize PCA
cat("\nPlotting PCA results...\n")
plot(CentDatum, main = "Centered Data")
abline(0, 1, col = "blue")  # Example: Plotting PC1 (replace values appropriately)
abline(0, -1, col = "red")  # Example: Plotting PC2 (replace values appropriately)

# Plot with equal aspect ratio
plot(CentDatum, asp = 1, main = "Centered Data with Equal Aspect Ratio")
abline(0, 1, col = "blue")
abline(0, -1, col = "red")

#### Principal Component Scores
cat("\nPrincipal component scores:\n")
print(results$scores)

#### Include Additional Variables in PCA
cat("\nAdding Ear Length to PCA...\n")
datum <- data.frame(Mass = datumFull$Mass, Body = datumFull$BodyLength, Ear = datumFull$Ear)
results <- princomp(datum)
summary(results)
print(results$loadings)

#### PCA with Scaled Data
cat("\nRunning PCA with scaled data...\n")
ScaleResults <- princomp(ScaleDatum)
summary(ScaleResults)
print(ScaleResults$loadings)

---
  
  ### Part 2: Factor Analysis ###
  
  #### Import Data for Factor Analysis
  cat("\nLoading dataset for Factor Analysis...\n")
datum <- read.csv(file.choose())
head(datum)

#### Run Exploratory Factor Analysis
cat("\nRunning Factor Analysis with 2 factors...\n")
results2 <- factanal(datum, factors = 2, scores = "regression")
print(results2)
cat("\nLatent variable scores:\n")
print(results2$scores)

#### Test Number of Factors
cat("\nTesting number of factors...\n")
results1 <- factanal(datum, factors = 1)
print(results1)
results3 <- factanal(datum, factors = 3)
print(results3)

---
  
  ### Part 3: Discriminant Function Analysis (DFA) ###
  
  #### Import Data for DFA
  cat("\nLoading dataset for DFA...\n")
datum <- read.csv(file.choose())
datum$Taxon <- factor(datum$Taxon)  # Ensure Taxon is treated as a factor
head(datum)

#### Visualize Data
cat("\nPlotting data using scatterplot matrix...\n")
library(lattice)
splom(~data.frame(Petals, Sepal, Leaf), data = datum, groups = Taxon)

#### Run MANOVA
cat("\nRunning MANOVA...\n")
results <- manova(cbind(Petals, Sepal, Leaf) ~ Taxon, data = datum)
summary(results)
summary.aov(results)

#### Run DFA
cat("\nRunning DFA...\n")
results <- lda(Taxon ~ Petals + Sepal + Leaf, data = datum)
print(results)

#### Plot DFA Results
cat("\nPlotting DFA results...\n")
plot(results, main = "DFA Results")

#### Evaluate Classification
cat("\nEvaluating DFA classification accuracy...\n")
predictions <- predict(results)
table(datum$Taxon, predictions$class)

#### Cross-Validation
cat("\nPerforming cross-validation...\n")
datum2 <- read.csv(file.choose())  # Load test dataset
datum2$Taxon <- factor(datum2$Taxon)
cv_predictions <- predict(results, datum2)
table(datum2$Taxon, cv_predictions$class)

---
  
  ### Notes ###
  
  # - Replace placeholder variable names (e.g., Mass, Body, Taxon) with the actual column names from your dataset.
  # - PCA:
  #   - Always check whether to use raw or scaled data.
  #   - Use `princomp` for R-mode PCA and `factanal` for exploratory factor analysis.
  # - DFA:
  #   - Evaluate model performance using cross-validation.
  #   - Modify `prior` argument in `lda` to adjust prior probabilities for classification.