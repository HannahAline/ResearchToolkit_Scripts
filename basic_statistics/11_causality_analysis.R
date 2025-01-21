##### Causality Modeling in R #####

# This script demonstrates:
# 1. Creating and analyzing Directed Acyclic Graphs (DAGs) using the `dagitty` package.
# 2. Determining adjustment sets for causal inference.
# 3. Comparing traditional statistical analyses with causal modeling.
# 4. Testing for missing links or unnecessary links in a DAG.

---
  
  ### Step 1: Install and Load Required Libraries ###
  
  # Install and load the `dagitty` and `MuMIn` packages
  if (!requireNamespace("dagitty", quietly = TRUE)) {
    install.packages("dagitty")
  }
if (!requireNamespace("MuMIn", quietly = TRUE)) {
  install.packages("MuMIn")
}
library(dagitty)
library(MuMIn)

---
  
  ### Part 1: Basic DAG Example ###
  
  #### Define and Plot a Simple DAG
  cat("\nDefining a simple DAG...\n")
DAG <- dagitty("dag{
              CWD -> SmMam -> WeasDens
              CWD -> WeasDens
}")
plot(DAG)  # Visualize the DAG

#### Define DAG with Custom Positions
cat("\nDefining a DAG with custom variable positions...\n")
DAG <- dagitty('dag{
              CWD [pos="0,0"]
              SmMam [pos="1,1"]
              WeasDens [pos="2,0"]
              CWD -> SmMam -> WeasDens
              CWD -> WeasDens
}')
plot(DAG)

#### Determine Adjustment Sets
cat("\nCalculating adjustment sets for causal effects...\n")

# Total effect of CWD on Weasel Density
adjustment_total <- adjustmentSets(DAG, "CWD", "WeasDens")
cat("Adjustment set for total effect of CWD on Weasel Density:\n")
print(adjustment_total)

# Effect of Small Mammal Density on Weasel Density
adjustment_sm <- adjustmentSets(DAG, "SmMam", "WeasDens")
cat("Adjustment set for Small Mammal Density on Weasel Density:\n")
print(adjustment_sm)

---
  
  ### Part 2: Complex DAG Example (Arif and MacNeil 2022) ###
  
  #### Import Data
  cat("\nLoading dataset for Arif and MacNeil example...\n")
datum <- read.csv(file.choose())
head(datum)

#### True Total Effect of Forestry on Species Y
cat("\nTrue total effect of Forestry on Species Y: -0.75\n")

---
  
  ### Traditional Analyses ###
  
  #### Run Full Model
  cat("\nRunning full model...\n")
results_full <- lm(SpeciesY ~ Forestry + SpeciesA + SpeciesZ + Fire + HumGrav + Climate, data = datum, na.action = na.fail)
summary(results_full)
confint(results_full)

#### Model Selection Using Dredge
cat("\nRunning model selection using dredge...\n")
dd <- dredge(results_full)
print(dd)

#### Model Averaging
cat("\nPerforming model averaging...\n")
test_avg <- model.avg(dd)
summary(test_avg)

---
  
  ### Causal Analysis ###
  
  #### Create Complex DAG
  cat("\nDefining a complex DAG...\n")
DAG <- dagitty('dag{
              Climate [pos="0,3"]
              Fire [pos="1,1"]
              Forestry [pos="2,2.5"]
              HumGrav [pos="2.5,0"]
              SpeciesA [pos="3,1.5"]
              SpeciesY [pos="4,2.5"]
              SpeciesZ [pos="2.5,4"]
              Climate -> Fire -> SpeciesA -> SpeciesY
              HumGrav -> Forestry -> SpeciesA
              HumGrav -> SpeciesY
              Climate -> Forestry
              Climate -> SpeciesY -> SpeciesZ
              Forestry -> SpeciesY
              Climate -> SpeciesZ
}')
plot(DAG)

#### Determine Adjustment Set for Forestry -> Species Y
cat("\nCalculating adjustment set for Forestry's effect on Species Y...\n")
adjustment_fy <- adjustmentSets(DAG, "Forestry", "SpeciesY")
print(adjustment_fy)

#### Run Multivariable Model
cat("\nRunning multivariable model based on causal adjustment set...\n")
results_causal <- lm(SpeciesY ~ Forestry + Climate + HumGrav, data = datum)
summary(results_causal)
confint(results_causal)

---
  
  ### Part 3: Testing Links in the DAG ###
  
  #### Testing Direct Effect of Forestry on Species A
  cat("\nTesting direct effect of Forestry on Species A...\n")
adjustment_fa <- adjustmentSets(DAG, "Forestry", "SpeciesA", effect = "direct")
cat("Adjustment set for Forestry -> Species A (direct):\n")
print(adjustment_fa)

results_direct <- lm(SpeciesA ~ Forestry + Climate, data = datum)
summary(results_direct)

#### Testing Missing Link Between HumGrav and Forestry
cat("\nTesting for a missing link between HumGrav and Forestry...\n")
adjustment_hf <- adjustmentSets(DAG, "HumGrav", "Forestry")
cat("Adjustment set for HumGrav -> Forestry:\n")
print(adjustment_hf)

results_missing <- lm(Forestry ~ HumGrav, data = datum)
summary(results_missing)

---
  
  ### Notes ###
  
  # - Replace variable names (e.g., Forestry, SpeciesY) with actual column names in your dataset.
  # - DAGs must be carefully constructed to reflect prior knowledge and plausible causal relationships.
  # - Use adjustment sets to identify confounders that need to be controlled for estimating causal effects.
  # - Causal inference requires domain expertise and careful consideration of underlying assumptions.