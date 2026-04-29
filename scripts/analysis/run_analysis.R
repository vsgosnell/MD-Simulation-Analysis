cat("Running MD analysis pipeline...\n")

source("scripts/analysis/convert_xvg_to_csv.R")
source("scripts/analysis/plot_rmsd.R")
source("scripts/analysis/plot_rmsf.R")
source("scripts/analysis/plot_rg.R")
source("scripts/analysis/plot_hbonds.R")

cat("Analysis complete. Plots saved to plots/.\n")
