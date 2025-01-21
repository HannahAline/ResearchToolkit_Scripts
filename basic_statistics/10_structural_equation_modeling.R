##### Structural Equation Modeling (SEM) in R #####

# This script demonstrates:
# 1. Building SEM models using the 'sem' package
# 2. Running SEM analyses and interpreting results
# 3. Standardizing path coefficients for clear interpretation

---
  
  ### Step 1: Install and Load Required Libraries ###
  
  # Install and load the 'sem' package
  if (!requireNamespace("sem", quietly = TRUE)) {
    install.packages("sem")
  }
library(sem)

# Access the documentation
help(sem)

---
  
  ### Step 2: Import Data ###
  
  # Prompt user to select a CSV file
  cat("Please select a CSV file to load your dataset.\n")
datum <- read.csv(file.choose())

# Confirm successful data import
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)

---
  
  ### Part 1: Specify SEM Model ###
  
  #### Define Path Model
  cat("\nDefining path model...\n")
modelPop <- specifyModel()
CWD <> CWD, CWDVar, NA         # Variance in coarse woody debris (CWD)
SmMDens <> SmMDens, MVar, NA   # Variance in small mammal density
WeasDens <> WeasDens, WVar, NA # Variance in weasel density
CWD > WeasDens, WeasVeg, NA    # Direct path: CWD to weasel density
CWD > SmMDens, PreyVeg, NA     # Direct path: CWD to small mammal density
SmMDens > WeasDens, WeasPrey, NA # Path: Small mammals to weasel density

cat("\nModel specification complete.\n")

---
  
  ### Part 2: Run SEM ###
  
  #### Run the Model
  cat("\nRunning SEM model...\n")
results <- sem(modelPop, data = datum)

#### Summary of Results
cat("\nSEM Model Summary:\n")
print(summary(results))

#### Standardized Coefficients
cat("\nCalculating standardized path coefficients...\n")
std_coeffs <- stdCoef(results)
cat("\nStandardized Path Coefficients:\n")
print(std_coeffs)

#### Interpret Standardized Coefficients
cat("\nInterpretation:\n")
cat("- Path coefficients for variances/errors represent unexplained variance (1 - R²).\n")
cat("- Path coefficients for paths represent the strength of relationships, accounting for other effects.\n")

---
  
  ### Part 3: Simplify the Model ###
  
  #### Define Simplified Path Model
  cat("\nDefining simplified path model...\n")
modelPop2 <- specifyModel()
CWD <> CWD, CWDVar, NA
SmMDens <> SmMDens, MVar, NA
WeasDens <> WeasDens, WVar, NA
SmMDens > WeasDens, WeasPrey, NA

cat("\nSimplified model specification complete.\n")

#### Run the Simplified Model
cat("\nRunning simplified SEM model...\n")
results2 <- sem(modelPop2, data = datum)

#### Summary of Results
cat("\nSimplified SEM Model Summary:\n")
print(summary(results2))

---
  
  ### Part 4: Example SEM with Karels et al. Data ###
  
  #### Log-Transform Data
  cat("\nPreparing Karels et al. dataset...\n")
datum$NativeBirds <- datum$NativeBirds + 1
datum$TotalExtinctions <- datum$TotalExtinctions + 1
datum$Predators <- datum$Predators + 1
datum_ln <- log(datum)

#### Define Path Model
cat("\nDefining Karels et al. path model...\n")
modelKarels <- specifyModel()
Area <> Area, AreaVar, NA
Isolation <> Isolation, IsoVar, NA
NativeBirds <> NativeBirds, BirdVar, NA
Predators <> Predators, PredVar, NA
TotalExtinctions <> TotalExtinctions, ExtVar, NA
Area <> Isolation, AreaIso, NA
Area > Predators, AreaPred, NA
Area > NativeBirds, AreaBirds, NA
Area > TotalExtinctions, AreaExt, NA
Isolation > NativeBirds, IsoBirds, NA
Isolation > TotalExtinctions, IsoExt, NA
Isolation > Predators, IsoPred, NA
NativeBirds > TotalExtinctions, BirdsExt, NA
Predators > TotalExtinctions, PredExt, NA

cat("\nKarels et al. model specification complete.\n")

#### Run Karels et al. SEM
cat("\nRunning Karels et al. SEM model...\n")
results_karels <- sem(modelKarels, data = datum_ln)

#### Summary of Results
cat("\nKarels et al. SEM Model Summary:\n")
print(summary(results_karels))

#### Standardized Coefficients
cat("\nCalculating standardized path coefficients...\n")
std_coeffs_karels <- stdCoef(results_karels)
cat("\nStandardized Path Coefficients for Karels et al.:\n")
print(std_coeffs_karels)

---
  
  ### Notes ###
  
  # - Replace variable names (e.g., CWD, SmMDens, Area) with actual column names from your dataset.
  # - Log-transform count data to address skewness, adding 1 to avoid issues with zeros.
  # - Use standardized coefficients (`stdCoef`) for clearer interpretation of SEM results.
  # - Ensure models are fully specified, with the number of parameters matching the number of observations.