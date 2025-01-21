##### Nested Designs and Pseudoreplication in R #####

# This script demonstrates:
# 1. Analyzing nested designs with random effects
# 2. Understanding and addressing pseudoreplication
# 3. Handling nested ANCOVA and split-plot designs

---
  
  ### Step 1: Load Required Libraries ###
  
  # Install and load necessary package
  if (!requireNamespace("nlme", quietly = TRUE)) {
    install.packages("nlme")
  }
library(nlme)

---
  
  ### Part 1: Random Effects in Nested Designs ###
  
  #### Import Dataset 1
  cat("Please select a CSV file for Dataset 1...\n")
datum <- read.csv(file.choose())
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)

#### Model Without Random Effects
cat("\nRunning model without random effects...\n")
results_no_random <- lm(Biomass ~ Treatment, data = datum)
cat("\nANOVA for Model Without Random Effects:\n")
print(anova(results_no_random))

#### Model With Random Effects
cat("\nRunning model with random effects for Field...\n")
results_random <- lme(Biomass ~ Treatment, data = datum, random = ~1 | Field)
cat("\nSummary of Model With Random Effects:\n")
print(summary(results_random))

#### Test Significance of Random Effect (Field)
cat("\nComparing models with and without random effects...\n")
anova_comparison <- anova(results_random, results_no_random)
cat("\nANOVA Comparison Results:\n")
print(anova_comparison)

# Note:
# - If Field is not a significant random effect, consider averaging within fields.
# - Model without Field assumes 18 samples, but random effects model correctly assumes 6.

---
  
  ### Part 2: Nested Designs ###
  
  #### Import Dataset 2
  cat("Please select a CSV file for Dataset 2...\n")
datum <- read.csv(file.choose())
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)

#### Nested Model: Plots Nested Within Fields
cat("\nRunning model with Plots nested within Fields...\n")
results_nested <- lme(Biomass ~ Treatment, data = datum, random = ~1 | Field/Plot)
cat("\nSummary of Nested Model:\n")
print(summary(results_nested))

#### Model Without Accounting for Fields
cat("\nRunning model with only Plots (ignoring Field)...\n")
results_plots_only <- lme(Biomass ~ Treatment, data = datum, random = ~1 | Plot)
cat("\nSummary of Model Ignoring Field:\n")
print(summary(results_plots_only))

# Note:
# - Ignoring Field inflates the number of samples due to pseudoreplication.

---
  
  ### Part 3: Split-Plot Designs ###
  
  #### Import Data for Split-Plot Analysis
  cat("Please select a CSV file for Split-Plot Analysis...\n")
datum <- read.csv(file.choose())
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)

#### Split-Plot Model: Nested Random Effects
cat("\nAnalyzing split-plot design...\n")
results_splitplot <- lme(Biomass ~ Cow + Fertilizer + Water, 
                         data = datum, random = ~1 | Field/Cow/Fertilizer)
cat("\nSummary of Split-Plot Model:\n")
print(summary(results_splitplot))
cat("\nANOVA for Split-Plot Model:\n")
print(anova(results_splitplot))

# Note:
# - Water plots are residual errors and do not need to be included in the random effects.

---
  
  ### Part 4: Nested ANCOVA ###
  
  #### Import Data for Nested ANCOVA
  cat("Please select a CSV file for Nested ANCOVA...\n")
datum <- read.csv(file.choose())
cat("\nPreview of the dataset (first 6 rows):\n")
head(datum)

#### ANCOVA: Individual Nested Within Sex
cat("\nRunning nested ANCOVA with Individual nested within Sex...\n")
results_ancova <- lme(Biomass ~ Age + Sex, data = datum, random = ~1 | Individual)
cat("\nSummary of Nested ANCOVA Model:\n")
print(summary(results_ancova))
cat("\nANOVA for Nested ANCOVA Model:\n")
print(anova(results_ancova))

#### Adding Interaction Between Age and Sex
cat("\nAdding interaction between Age and Sex to nested ANCOVA...\n")
results_interaction <- lme(Biomass ~ Age + Sex + Sex:Age, 
                           data = datum, random = ~1 | Individual)
cat("\nSummary of Model With Interaction:\n")
print(summary(results_interaction))
cat("\nANOVA for Model With Interaction:\n")
print(anova(results_interaction))

# Note:
# - Interaction effects (e.g., Sex:Age) are not pseudoreplicated and use the full error term.

---
  
  ### Notes ###
  
  # - Replace variable names (e.g., Biomass, Treatment, Field, Plot) with your dataset's column names.
  # - Be cautious of pseudoreplication in nested designs and ensure random effects are correctly specified.
  # - For split-plot designs, ensure nested factors (e.g., Field/Cow/Fertilizer) are included in the random effects.
  
  ### End of Script ###
  