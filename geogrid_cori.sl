#!/usr/bin/env /bin/bash
#SBATCH -p debug
#SBATCH -N 1
#SBATCH -t 00:30:00
#SBATCH -C haswell
#SBATCH -A <account id>

time
date
cd $SCRATCH/WRF_CLIMATE/WPS-4.0.1

rm geogrid*.log
srun -n 1 ./geogrid.exe >& geogrid_cori.log

time
date
