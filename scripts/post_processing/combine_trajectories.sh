#!/bin/bash
#SBATCH --job-name=combine_traj
#SBATCH --output=logs/combine_traj_%j.out
#SBATCH --error=logs/combine_traj_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=02:00:00

set -euo pipefail

###############################################################################
# combine_trajectories.sh
#
# Purpose:
#   Combine production trajectory segments and generate centered, PBC-corrected
#   trajectories for downstream analysis.
#
# Inputs:
#   - step3_input.gro
#   - step5_production.tpr
#   - step5_production.xtc
#   - step5_production.part*.xtc, if present
#
# Outputs:
#   - index.ndx
#   - step-all.xtc
#   - out.xtc
#   - out_prot.xtc
###############################################################################

mkdir -p logs

echo "Starting trajectory combination and processing"
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
START_STRUCTURE="step3_input.gro"
TRAJ_PREFIX="step5_production"
MAIN_TRAJ="${TRAJ_PREFIX}.xtc"
COMBINED_TRAJ="step-all.xtc"
CENTERED_TRAJ="out.xtc"
PROTEIN_TRAJ="out_prot.xtc"
INDEX_FILE="index.ndx"

for file in "$TPR_FILE" "$START_STRUCTURE" "$MAIN_TRAJ"; do
    if [[ ! -f "$file" ]]; then
        echo "ERROR: Required file not found: $file"
        exit 1
    fi
done

echo "Generating default index file..."
echo "q" | mpirun -np 1 gmx_mpi make_ndx \
    -f "$START_STRUCTURE" \
    -o "$INDEX_FILE"

echo "Combining trajectory segments..."

TRAJ_PARTS=$(ls -1 ${TRAJ_PREFIX}.part*.xtc 2>/dev/null | tr '\n' ' ' || true)

if [[ -n "$TRAJ_PARTS" ]]; then
    mpirun -np 1 gmx_mpi trjcat \
        -f "$MAIN_TRAJ" $TRAJ_PARTS \
        -o "$COMBINED_TRAJ"
else
    echo "No trajectory part files found. Copying main trajectory to ${COMBINED_TRAJ}."
    cp "$MAIN_TRAJ" "$COMBINED_TRAJ"
fi

echo "Applying PBC correction and centering full system..."
echo "1 0" | mpirun -np 1 gmx_mpi trjconv \
    -f "$COMBINED_TRAJ" \
    -s "$TPR_FILE" \
    -n "$INDEX_FILE" \
    -pbc mol \
    -ur compact \
    -center \
    -o "$CENTERED_TRAJ"

echo "Applying PBC correction and centering protein trajectory..."
echo "1 1" | mpirun -np 1 gmx_mpi trjconv \
    -f "$COMBINED_TRAJ" \
    -s "$TPR_FILE" \
    -n "$INDEX_FILE" \
    -pbc mol \
    -ur compact \
    -center \
    -o "$PROTEIN_TRAJ"

echo "Trajectory combination and processing completed successfully"
echo "End time: $(date)"
