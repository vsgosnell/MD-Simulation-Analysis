# Molecular Dynamics Analysis of Vaccine-Receptor Complexes

## Overview
This repository contains a reproducible pre-processing, post-processing, and visualization workflow for molecular dynamics simulations of vaccine-receptor complexes. The pipeline was developed to analyze structural stability, flexibility, compactness, and hydrogen bonding patterns from GROMACS simulation outputs.

The workflow includes scripts for converting GROMACS `.xvg` files into clean `.csv` files, generating publication-ready plots, and documenting the full analysis from raw pre-processing output to final figures.

## Analyses Included
- Minimization and Equilibration
- Molecular Dynamics Production run
- Combine multiple MD run trajectories 
- Root mean square deviation (RMSD)
- Root mean square fluctuation (RMSF)
- Radius of gyration (Rg)
- Intramolecular hydrogen bond analysis
- Extract Average Frame from MD simulation run
- Electrostatic Surface Representations
- Integrated Binding Mode Diagram

## Repository Structure
- `scripts/` — R scripts for file conversion, analysis, and plotting
- `data/` — small example datasets used to demonstrate the workflow
- `plots/` — example output figures generated from the analysis scripts
- `docs/` — step-by-step workflow documentation and analysis vignette
- `results/` — placeholder folder for local full-size results, excluded from GitHub when necessary

## Tools Used
- GROMACS
- R
- ggplot2
- PyMOL

## Data Availability
Full molecular dynamics trajectories and large simulation outputs are not included due to file size and ongoing research considerations.

Representative processed datasets are provided in the `data/` directory so that the analysis workflow can be reproduced. Users may substitute their own GROMACS-derived `.xvg` or `.csv` files using the same expected format.

## Reproducing the Example Analysis

Run the full example workflow from the repository root:

```r
source("scripts/06_generate_all_plots.R") 
```

## Run Individual Analyses

Each analysis can also be executed independently:

```r
source("scripts/02_plot_rmsd.R")
source("scripts/03_plot_rmsf.R")
source("scripts/04_plot_rg.R")
source("scripts/05_plot_hbonds.R")
```

## Citation

If you use or adapt this workflow, please cite this repository.

A formal manuscript describing this pipeline is in preparation.
