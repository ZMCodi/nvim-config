#!/bin/bash --login

# for reference, see https://ri.itservices.manchester.ac.uk/csf3/batch-slurm/

#SBATCH -p serial
#SBATCH -t 5

#SBATCH -o %x.%j.out

module purge
