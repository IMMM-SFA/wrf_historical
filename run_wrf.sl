#!/bin/bash 
#SBATCH -N 1
#SBATCH --time=02:00:00
#SBATCH --export=ALL
#SBATCH -p regular 
#SBATCH -L SCRATCH
#SBATCH -C knl
#SBATCH -J wrf_conus
#SBATCH -o wrf_conus.o%j
#SBATCH -A m2702

date

export OMP_NUM_THREADS=1
export FOR_IGNORE_EXCEPTIONS=1
ulimit -s unlimited

module unload craype-haswell
module load craype-mic-knl
module load impi
module load cray-parallel-netcdf
export PNETCDF=${PARALLEL_NETCDF_DIR}
module load cray-hdf5
export HDF5=${HDF5_DIR}
module load png
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
export WRF_EM_CORE=1
module load jasper
export JASPERLIB=/global/common/cori/software/jasper/1.900.1/hsw/intel/lib
export JASPERINC=/global/common/cori/software/jasper/1.900.1/hsw/intel/include

srun ./wrf.exe

date
