#!/bin/bash
#SBATCH --job-name=prod_run2
#SBATCH --output=logs/prod_run2_%j.out
#SBATCH --error=logs/prod_run2_%j.err
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=24
#SBATCH --time=4-00:00:00

set -euo pipefail

###############################################################################
# production_run2.sh
#
# Purpose:
#   Continue production MD simulation from checkpoint file.
#
# Inputs:
#   - step5_production.tpr
#   - step5_production.cpt
#
# Outputs:
#   - Continued trajectory files (new segment)
###############################################################################

mkdir -p logs

echo "Starting production run 2 (continuation)"
echo "Job ID: ${SLURM_JOB_ID:-local}"
echo "Running on: $(hostname)"
echo "Start time: $(date)"

# Load modules
module purge
module load mpi/openmpi
module load apps/gromacs/2020.4

# MPI / GROMACS environment settings
export OMPI_MCA_pml=ob1
export OMPI_MCA_btl=tcp,self,sm
export LD_LIBRARY_PATH=/usr/lib64/psm2-compat:${LD_LIBRARY_PATH:-}
export GMX_MAXCONSTRWARN=-1

# Input files
TPR_FILE="step5_production.tpr"
CPT_FILE="step5_production.cpt"
PREFIX="step5_production"

# Validate inputs
for file in "$TPR_FILE" "$CPT_FILE"; do
    if [[ ! -f "$file" ]]; then
        echo "ERROR: Required file not found: $file"
        exit 1
    fi
done

# Total cores from SLURM allocation
TOTAL_CORES=$(( SLURM_NNODES * SLURM_NTASKS_PER_NODE ))

echo "Using $TOTAL_CORES MPI ranks"

###############################################################################
# Continue production MD
###############################################################################

echo "Continuing production MD from checkpoint..."

mpirun -np "$TOTAL_CORES" gmx_mpi mdrun \
    -v \
    -deffnm "$PREFIX" \
    -cpi "$CPT_FILE" \
    -noappend \
    -nb cpu

echo "Production run 2 completed successfully"
echo "End time: $(date)"
