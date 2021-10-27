#!/usr/bin/env /bin/bash
#SBATCH -J create_WRF_input
#SBATCH -p regular
#SBATCH -N 6
#SBATCH -t 23:00:00
#SBATCH -C knl
#SBATCH -A <account id>
time
date
srun -n 192 ./real.exe
time
date
