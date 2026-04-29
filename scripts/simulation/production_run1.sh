#!/bin/bash
#SBATCH --job-name=prod_run1
#SBATCH --output=logs/prod_run1_%j.out
#SBATCH --error=logs/prod_run1_%j.err
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=24
#SBATCH --time=4-00:00:00

set -euo pipefail

###############################################################################
# production_run1.sh
#
# Purpose:
#   Perform first production MD simulation using equilibrated system.
#
# Inputs:
#   - step4.1_equilibration.gro
#   - step3_input.gro
#   - topol.top
#   - index.ndx
#   - step5_production.mdp
#
# Outputs:
#   - step5_production.*
###############################################################################

mkdir -p logs

echo "Starting production run 1"
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
INPUT_GRO="step4.1_equilibration.gro"
REFERENCE_GRO="step3_input.gro"
TOPOLOGY="topol.top"
INDEX="index.ndx"
MDP_FILE="step5_production.mdp"

TPR_FILE="step5_production.tpr"
PREFIX="step5_production"

# Validate inputs
for file in "$INPUT_GRO" "$REFERENCE_GRO" "$TOPOLOGY" "$INDEX" "$MDP_FILE"; do
    if [[ ! -f "$file" ]]; then
        echo "ERROR: Required file not found: $file"
        exit 1
    fi
done

# Total cores (matches SLURM allocation)
TOTAL_CORES=$(( SLURM_NNODES * SLURM_NTASKS_PER_NODE ))

echo "Using $TOTAL_CORES MPI ranks"

###############################################################################
# Step 1: Generate TPR
###############################################################################

echo "Generating TPR file..."

mpirun -np "$TOTAL_CORES" gmx_mpi grompp \
    -f "$MDP_FILE" \
    -c "$INPUT_GRO" \
    -r "$REFERENCE_GRO" \
    -p "$TOPOLOGY" \
    -n "$INDEX" \
    -o "$TPR_FILE"

###############################################################################
# Step 2: Run production MD
###############################################################################

echo "Running production MD..."

mpirun -np "$TOTAL_CORES" gmx_mpi mdrun \
    -v \
    -deffnm "$PREFIX" \
    -nb cpu

echo "Production run 1 completed successfully"
echo "End time: $(date)"
