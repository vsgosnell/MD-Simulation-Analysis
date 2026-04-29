#!/bin/bash
#SBATCH --job-name=avg_frame
#SBATCH --output=logs/avg_frame_%j.out
#SBATCH --error=logs/avg_frame_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=02:00:00

set -euo pipefail

###############################################################################
# extract_average_frame.sh
#
# Purpose:
#   Fit the combined MD trajectory, cluster representative structures, and
#   extract a representative central structure from the simulation.
#
# Inputs:
#   - step5_production.tpr
#   - step-all.xtc
#   - index.ndx
#
# Outputs:
#   - fitted.xtc
#   - clusters.xpm
#   - cluster.log
#   - central_structures.pdb
#   - md_rep_structure.pdb
###############################################################################

mkdir -p logs

echo "Starting representative structure extraction"
echo "Job ID: ${SLURM_JOB_ID:-local}"
echo "Running on: $(hostname)"
echo "Start time: $(date)"

module purge
module load mpi/openmpi
module load apps/gromacs/2020.4

export OMPI_MCA_pml=ob1
export OMPI_MCA_btl=tcp,self,sm
export LD_LIBRARY_PATH=/usr/lib64/psm2-compat:${LD_LIBRARY_PATH:-}
export GMX_MAXCONSTRWARN=-1

TPR_FILE="step5_production.tpr"
TRAJECTORY="step-all.xtc"
INDEX_FILE="index.ndx"

FITTED_TRAJ="fitted.xtc"
CLUSTER_XPM="clusters.xpm"
CLUSTER_LOG="cluster.log"
CENTRAL_STRUCTURES="central_structures.pdb"
REP_STRUCTURE="md_rep_structure.pdb"

for file in "$TPR_FILE" "$TRAJECTORY" "$INDEX_FILE"; do
    if [[ ! -f "$file" ]]; then
        echo "ERROR: Required file not found: $file"
        exit 1
    fi
done

echo "Fitting trajectory using rotational and translational alignment..."
echo "1 1" | mpirun -np 1 gmx_mpi trjconv \
    -s "$TPR_FILE" \
    -f "$TRAJECTORY" \
    -o "$FITTED_TRAJ" \
    -fit rot+trans

echo "Clustering fitted trajectory using the GROMOS method..."
echo "1 1" | mpirun -np 1 gmx_mpi cluster \
    -s "$TPR_FILE" \
    -f "$FITTED_TRAJ" \
    -n "$INDEX_FILE" \
    -o "$CLUSTER_XPM" \
    -g "$CLUSTER_LOG" \
    -cl "$CENTRAL_STRUCTURES" \
    -method gromos \
    -cutoff 0.25

echo "Extracting representative structure..."
echo "1" | mpirun -np 1 gmx_mpi trjconv \
    -f "$CENTRAL_STRUCTURES" \
    -s "$TPR_FILE" \
    -o "$REP_STRUCTURE" \
    -dump 0

echo "Representative structure extraction completed successfully"
echo "End time: $(date)"
