## System Preparation
- Protein–protein complexes were prepared using CHARMM-GUI.
- The CHARMM36 force field was applied for protein parameterization.
- Systems were solvated using the TIP3P water model.
- Appropriate counterions were added to neutralize the system.
- CHARMM-GUI was used to generate GROMACS-compatible input files (`.gro`, `.top`, `.itp`, `.mdp`).

---

## Simulation Stages
1. Energy minimization (steepest descent algorithm, GROMACS)
2. Equilibration:
   - NPT ensemble (constant number of particles, pressure, and temperature)
3. Production MD simulations (100 ns, GROMACS) 

---

## Trajectory Processing
- Multiple MD runs were combined where applicable
- Trajectories were processed using GROMACS tools prior to analysis

---

## Notes on Index Groups

Several GROMACS commands in this workflow require selecting atom groups (e.g., Protein, Backbone, C-alpha) using an `index.ndx` file.

Group numbers (e.g., `1`, `0`, `4`) are system-dependent and may vary depending on how the index file is generated.

Users should verify group indices using:

```bash
gmx make_ndx -f input.gro -o index.ndx
```

---

## Analyses Performed
- Root mean square deviation (RMSD)
- Root mean square fluctuation (RMSF)
- Radius of gyration (Rg)
- Intramolecular hydrogen bond analysis

## Visualization
- MD analysis plots were generated in R using ggplot2
- Structural visualizations and electrostatic surface representations were generated using PyMOL
