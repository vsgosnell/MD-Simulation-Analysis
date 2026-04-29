# Molecular Dynamics Analysis of Vaccine–Receptor Complexes

## Overview

This repository provides a reproducible workflow for the **pre-processing, post-processing, and visualization** of molecular dynamics (MD) simulations of vaccine–receptor complexes generated using GROMACS. The pipeline is designed to evaluate key structural properties including stability, flexibility, compactness, and hydrogen bonding behavior.

The workflow emphasizes modularity and reproducibility, enabling users to apply the same analysis pipeline to multiple simulation runs and complexes.

---

## Analyses Included

### Simulation Workflow (GROMACS)
- Structure preparation and topology generation (CHARMM → GROMACS conversion
- Energy minimization  
- Equilibration (NVT/NPT)  
- Molecular dynamics production run  

### Trajectory Processing
- Combination of multiple MD trajectories  
- Extraction of average structures from simulation trajectories  

### Structural Analyses
- Root mean square deviation (RMSD)  
- Root mean square fluctuation (RMSF)  
- Radius of gyration (Rg)  
- Intramolecular hydrogen bond analysis  

### Structural Visualization & Post-Processing
- Electrostatic surface representations  
- Integrated binding mode diagrams  

---

## Repository Structure

```
scripts/
├── simulation/
│   ├── minimization_equilibration.sh
│   ├── production_run1.sh
│   └── production_run2.sh
│
├── post_processing/
│   ├── combine_trajectories.sh
│   └── extract_average_frame.sh
│
└── analysis/
    ├── convert_xvg_to_csv.R
    ├── plot_rmsd.R
    ├── plot_rmsf.R
    ├── plot_rg.R
    ├── plot_hbonds.R
    └── generate_all_plots.R

├── data/           # (.csv format)
├── plots/          
├── docs/           
└── results/        
```

---

## Tools and Software

- **GROMACS** — molecular dynamics simulations and trajectory analysis  
- **R** — data processing and statistical analysis  
- **ggplot2** — data visualization  
- **PyMOL** — structural visualization and figure generation  

---

## Data Availability

Full molecular dynamics trajectories (e.g., `.xtc`, `.trr`) and large simulation outputs are not included due to file size limitations and ongoing research considerations.

Representative processed datasets are provided in the `data/` directory to demonstrate the analysis workflow. Users may substitute their own GROMACS-generated outputs using the same input format.

---

## Reproducing the Analysis

### Simulation

Energy minimization and equilibration are performed sequentially within a single script, followed by the production runs:

```bash
bash scripts/simulation/minimization_equilibration.sh
bash scripts/simulation/production_run1.sh
bash scripts/simulation/production_run2.sh
```


### Run Complete Workflow

From the repository root:

```r
source("scripts/generate_all_plots.R")
```

## Run Individual Analyses

Each analysis can also be executed independently:

```r
source("scripts/plot_rmsd.R")
source("scripts/plot_rmsf.R")
source("scripts/plot_rg.R")
source("scripts/plot_hbonds.R")
```

## Input Requirements

The workflow expects processed GROMACS output files (converted to `.csv`), derived from:

- RMSD (`gmx rms`)
- RMSF (`gmx rmsf`)
- Radius of gyration (`gmx gyrate`)
- Hydrogen bonds (`gmx hbond`)

Conversion from `.xvg` to `.csv` can be performed using:

```r
source("scripts/convert_xvg_to_csv.R")
```

## Documentation

Detailed step-by-step instructions for the full workflow, including `GROMACS` post-processing commands and analysis procedures, are provided in:

```r
docs/md_analysis_vignette.md
```

## Citation

If you use or adapt this workflow, please cite this repository.

A formal manuscript describing this pipeline is currently in preparation.
