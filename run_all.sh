#!/bin/bash

###############################################################################
# run_all.sh
#
# Purpose:
#   Submit full MD pipeline using SLURM job dependencies.
#
# Workflow:
#   1. Minimization + Equilibration
#   2. Production Run 1
#   3. Production Run 2 (continuation)
#   4. Combine trajectories
#   5. Extract representative structure
###############################################################################

set -e

echo "Submitting MD pipeline..."

# Step 1: Minimization + Equilibration
job1=$(sbatch scripts/simulation/minimization_equilibration.sh | awk '{print $4}')
echo "Submitted minimization_equilibration (Job ID: $job1)"

# Step 2: Production Run 1
job2=$(sbatch --dependency=afterok:$job1 scripts/simulation/production_run1.sh | awk '{print $4}')
echo "Submitted production_run1 (Job ID: $job2)"

# Step 3: Production Run 2 (continuation)
job3=$(sbatch --dependency=afterok:$job2 scripts/simulation/production_run2.sh | awk '{print $4}')
echo "Submitted production_run2 (Job ID: $job3)"

# Step 4: Combine trajectories
job4=$(sbatch --dependency=afterok:$job3 scripts/post_processing/combine_trajectories.sh | awk '{print $4}')
echo "Submitted combine_trajectories (Job ID: $job4)"

# Step 5: Extract representative structure
job5=$(sbatch --dependency=afterok:$job4 scripts/post_processing/extract_average_frame.sh | awk '{print $4}')
echo "Submitted extract_average_frame (Job ID: $job5)"

echo "All jobs submitted successfully."
