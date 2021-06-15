#!/bin/bash 
#SBATCH -N 7         #Use 4 nodes
#SBATCH --time=48:00:00      #the max walltime allowed for flex QOS jobs
#SBATCH --export=ALL
#SBATCH -p regular   #Submit to the regular 'partition'
#SBATCH -L SCRATCH   #Job requires $SCRATCH file system
#SBATCH -C haswell   #Use KNL nodes in quad cache format (default, recommended)
#SBATCH -J conus_v1
#SBATCH -o conus_V1.o%j
#SBATCH -A m2637

date

#TOP of the script
#1. check sqs 
#    1. if 2 Rs stop
#    2. if 1 R continue
#2. check rsl
#    1. if moving stop
#    2. if not moving read: the last date and continue
#3. run RESTART script 

###checking sqs
##sleep 30;
##sqs >& s_sqs_temp
##status=$(awk '/'"Sample_V11"'/ {print $2}' s_sqs_temp)
##rm s_sqs_temp
##status=$(echo $status)
##status_count=$(echo "${status}" | awk -F "R" '{print NF-1}')
##echo "checking sqs, # of R jobs: $status_count"

##if [ $status_count -gt 1 ]
##then
##echo "EXIT: more than one active job, # of R jobs: $status_count"
##exit


###elif for checking sqs
##elif [ $status_count -eq 1 ]
##then
##echo "Only one active job, # of R jobs: $status_count"
##sleep 30;


###checking sqs AGAIN
##sqs >& s_sqs_temp
##status=$(awk '/'"Sample_V11"'/ {print $2}' s_sqs_temp)
##rm s_sqs_temp
##status=$(echo $status)
##status_count=$(echo "${status}" | awk -F "R" '{print NF-1}')
##echo "checking sqs AGAIN, # of R jobs: $status_count"

##if [ $status_count -gt 1 ]
##then
##echo "EXIT: more than one active job AGAIN, # of R jobs: $status_count"
##exit


###elif for checking sqs AGAIN
##elif [ $status_count -eq 1 ]
##then
##echo "Only one active job AGAIN, # of R jobs: $status_count"


###get the last date rsl was modified
##last_rsl_old=$(stat -c %Y rsl.error.0000)
##echo "old rsl.error.0000 date: $last_rsl_old"
##sleep 60;
##last_rsl_new=$(stat -c %Y rsl.error.0000)
##echo "new rsl.error.0000 date after 1 min: $last_rsl_new"
##if [ $last_rsl_old -eq $last_rsl_new ]
##then
##echo "RSL.ERROR.0000 check: simulation is stopped"








#pre-sets
export OMP_NUM_THREADS=1
#  setenv ATP_ENABLED 1
export FOR_IGNORE_EXCEPTIONS=1
ulimit -s unlimited

#running s_restartV7 and wrf
for restart_count in {1..362}
do

if [ -f ./wrfbdy_d01 ] && [ -f ./wrffdda_d01 ] && [ -f ./wrflowinp_d01 ] && [ -f ./wrf.exe ] && [ -f ./rsl.error.0000 ]
then
echo "running s_restartV6 $restart_count"
./s_restartV6
echo "running WRF $restart_count"
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
rm rsl.*
srun -n 112 -c 4 --cpu_bind=cores ./wrf.exe
else
echo "no input files"
fi 

done







### sanity check for checking RSL.ERROR.0000
##else
##echo "EXIT: RSL.ERROR.0000 check: simulation is still running"
##exit
### fi for get the last date on rsl
##fi


###sanity check for checking sqs AGAIN
##else
##echo "EXIT: sanity check failed in checking sqs AGAIN, # of R jobs: $status_count"
##exit
###fi for checking sqs AGAIN
##fi


###sanity check for checking sqs
##else
##echo "EXIT: sanity check failed in checking sqs, # of R jobs: $status_count"
##exit
###fi for checking sqs
##fi

