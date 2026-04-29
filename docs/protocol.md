## System Preparation
- Protein–protein complexes were prepared using CHARMM-GUI.
- The CHARMM36 force field was applied for protein parameterization.
- Systems were solvated using the TIP3P water model.
- Appropriate counterions were added to neutralize the system.
- CHARMM-GUI was used to generate GROMACS-compatible input files (`.gro`, `.top`, `.itp`, `.mdp`).

## Simulation Stages
1. Energy minimization (steepest descent algorithm, GROMACS)
2. Equilibration:
   - NVT ensemble (constant number of particles, volume, and temperature)
   - NPT ensemble (constant number of particles, pressure, and temperature)
3. Production MD simulations (100 ns, GROMACS)

## Trajectory Processing
- Multiple MD runs were combined where applicable
- Trajectories were processed using GROMACS tools prior to analysis

## Analyses Performed
- Root mean square deviation (RMSD)
- Root mean square fluctuation (RMSF)
- Radius of gyration (Rg)
- Intramolecular hydrogen bond analysis

## Visualization
- MD analysis plots were generated in R using ggplot2
- Structural visualizations and electrostatic surface representations were generated using PyMOL
