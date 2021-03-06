#!/usr/bin/env /bin/bash
#SBATCH -J Un8
#SBATCH -p regular
#SBATCH -N 1
#SBATCH --gres=craynetwork:2
#SBATCH -t 01:00:00
#SBATCH -C haswell
#SBATCH -A <account id>
time
date
cd $SCRATCH/WRF_CLIMATE/WPS-4.0.1
srun -n 1 -c 2 --mem=50000 --gres=craynetwork:1  ./ungrib.exe >& ungrib_cori.log &
wait
time
date
