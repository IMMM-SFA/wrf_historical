
1. Download and compile WRFv4.0.1 (which will be used for metgrid):
  * `cd $SCRATCH/WRF_CLIMATE`
  * `wget https://github.com/wrf-model/WRF/archive/refs/tags/v4.0.1.zip`
  * `unzip v4.0.1.zip`
  * `cd WRF-4.0.1`
  * Load important modules:
    * You may need to unload some other modules first
    * `module load craype-haswell`
    * `module load impi`
  * `./configure`
    * On NERSC, you first need to set the NETCDF environment variable: `export NETCDF=/opt/cray/pe/netcdf/default/INTEL/19.0`
    * On NERSC, choose architecture 66 for Intel HSW (dmpar)
    * Choose 1=basic
  * `./compile wrf`

1. Download and compile WRFv4.2.1:
  * `cd $SCRATCH/WRF_CLIMATE`
  * `wget https://github.com/wrf-model/WRF/archive/refs/tags/v4.2.1.zip`
  * `unzip v4.2.1.zip`
  * `cd WRF-4.2.1`
  * Load important modules:
    * You may need to unload some other modules first
    * `module load cray-netcdf`
    * `export NETCDF=${NETCDF_DIR}`
    * `module load cray-parallel-netcdf`
    * `export PNETCDF=${PARALLEL_NETCDF_DIR}`
    * `module load cray-hdf5`
    * `export HDF5=${HDF5_DIR}`
    * `module load craype-mic-knl`
    * `module load impi`
    * `module load png`
    * `module load jasper`
    * `export JASPERLIB=/global/common/cori/software/jasper/1.900.1/hsw/intel/lib`
    * `export JASPERINC=/global/common/cori/software/jasper/1.900.1/hsw/intel/include`
  * `./configure`
    * On NERSC, choose architecture 70 for INTEL KNL MIC (dmpar)
    * Choose 1=basic
  * Within the file `congigure.wrf` update the setting for BUILD_RRTMG_FAST:
    * `-DBUILD_RRTMG_FAST=1`
  * Compile WRF with:
    * `./compile em_real`
  * Copy the file `namelist.input` to the WRF directory:
    * `cp namelist.input $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/namelist.input`

1. Download and compile the WRF Pre-processing System (WPS) Version 4.0.1:
  * `cd $SCRATCH/WRF_CLIMATE`
  * `wget https://github.com/wrf-model/WPS/archive/refs/tags/v4.0.1.zip`
  * `unzip v4.0.1.zip`
  * `cd WPS-4.0.1`
  * Load important modules:
    * You may need to unload some other modules first
    * `module load craype-haswell`
    * `module unload impi`
  * `./configure`
    * On NERSC, you first need to set the NETCDF environment variable: `export NETCDF=${NETCDF_DIR}`
    * On NERSC, choose architecture 39: "Cray XC CLE/Linux x86_64, Intel compiler"
  * Set the path to the WRF installation:
    * In `configure.wps`, add a line around line 56 like: `WRF_DIR = ../WRF-4.2.1`
  * `./compile`

1. Download the static WRF geographical data from https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html. All the relevant links are:
    * https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
    * https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
    * https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
    * https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
    * https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
    * https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
    * https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
    * https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
    * https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
    * https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
    * https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
    * Unpack all these files into the same directory and note the location; for this walkthrough let's say we put them at `$SCRATCH/WRF_CLIMATE/GEOGRAPHY`

1. Set the following options in the `$SCRATCH/WRF_CLIMATE/WPS-4.0.1/namelist.wps` file:
  * `max_dom = 1,`
  * `interval_seconds = 10800,`
  * `e_we = 425,`
  * `e_sn = 300,`
  * `geog_data_res   = 'nlcd2011_9s+modis_fpar+modis_lai',`
  * `dx = 12000,`
  * `dy = 12000,`
  * `map_proj = 'lambert'`,
  * `ref_lat   =  40.0,`
  * `ref_lon   = -97.0,`
  * `truelat1  =  30.0,`
  * `truelat2  =  45.0,`
  * `stand_lon = -97.0,`
  * `geog_data_path = '$SCRATCH/WRF_CLIMATE/GEOGRAPHY',` (replace with directory from step 3!)
  * `fg_name = 'FILE', 'SST',`
  * `constants_name = 'FIX:1979-01-01_00',`

1. Generate the grid file:
  * Submit the job with:
    * `sbatch geogrid_cori.sl`
  * When the job completes, confirm that the file `geo_em.d01.nc` was created in the `WPS-4.0.1` directory and is about 25 MB

1. Download and process the time invariant ERA5 grib files:
  * On NERSC, run `module load globus-tools` to access the Globus utilities
  * Run the script `downloadInvariantFiles.sh` to create a Globus task for downloading the time invariant files to `$SCRATCH/WRF_CLIMATE/invariant`
  * If you haven't used the Globus tools before, there will be a step to authorize NERSC to use your Globus account
  * `cd $SCRATCH/WRF_CLIMATE/WPS-4.0.1`
  * Link the invariant files:
    * `./link_grib.csh $SCRATCH/WRF_CLIMATE/invariant/*grb`
  * Link the ERA VTable:
    * `ln -s ./ungrib/Variable_Tables/Vtable.ERA-interim.pl Vtable`
  * In `namelist.wps`:
    * update `prefix = 'FIX',`
    * update `start_date = '1979-01-01_00:00:00',`
    * update `end_date = '1979-01-01_00:00:00',`
  * Submit the batch job to ungrib with `sbatch ungrib_cori.invariant.sl`
  * When the job completes, you should see a file `FIX:1979-01-01_00`
  * Delete the supporting file:
    * `rm GRIBFILE.*`

1. Download the relevant ERA5 grib files for the year you want to simulate:
  * On NERSC, run `module load globus-tools` to access the Globus utilities
  * Run the script `createFileListForYear.sh <year>` to create a list of ERA5 files needed for that year, which will create `$SCRATCH/WRF_CLIMATE/<year>/transfer_jan-jun.txt` and `$SCRATCH/WRF_CLIMATE/<year>/transfer_jul-dec.txt`
  * Download data for Jan-Jun of that year:
    * `transfer_files.py -s 1e128d3c-852d-11e8-9546-0a6d4e044368 -t dtn -i $SCRATCH/WRF_CLIMATE/<year>/transfer_jan-jun.txt -d $SCRATCH/WRF_CLIMATE/<year>/jan-jun`
    * This will create a Globus task which will eventually succeed and notify you by email
  * Download data for Jul-Dec of that year:
    * `transfer_files.py -s 1e128d3c-852d-11e8-9546-0a6d4e044368 -t dtn -i $SCRATCH/WRF_CLIMATE/<year>/transfer_jul-dec.txt -d $SCRATCH/WRF_CLIMATE/<year>/jul-dec`
    * This will create a Globus task which will eventually succeed and notify you by email

1. Copy the entire `WPS-4.0.1` directory to a 6-month-specific directories:
  * `cp -r $SCRATCH/WRF_CLIMATE/WPS-4.0.1 $SCRATCH/WRF_CLIMATE/WPS_<year>_jan-jun`
  * `cp -r $SCRATCH/WRF_CLIMATE/WPS-4.0.1 $SCRATCH/WRF_CLIMATE/WPS_<year>_jul-dec`

1. Perform the first WPS preprocessing:
  * `cd $SCRATCH/WRF_CLIMATE/WPS_<year>_jan-jun`
  * Link the ERA5 forcing data for this 6 month period:
    * `./link_grib.csh $SCRATCH/WRF_CLIMATE/<year>/jan-jun/*grb`
  * Link the ERA VTable:
    * `ln -sf ./ungrib/Variable_Tables/Vtable.ERA-interim.pl Vtable`
  * Update the `namelist.wps`:
    * set `prefix = 'FILE',`
    * set `start_date = '<year>-01-01_00:00:00',`
    * set `end_date = '<year>-06-30_21:00:00',`
  * Repeat the above steps for `jul-dec`, making sure to update the start and end dates
  * Submit the job with:
    * `sbatch ungrib_cori.sl_year <year>`
  * When the job completes, make sure the `WPS_<year>_<months>` directories have the three-hourly files that look like `FILE:<date>_<time>`

1. Perform the second WPS preprocessing: (TODO maybe not necessary)
  * `cd $SCRATCH/WRF_CLIMATE/WPS_<year>_jan-jun`
  * Link the SST VTable:
    * `ln -sf ./ungrib/Variable_Tables/Vtable.SST Vtable`
  * Update the `namelist.wps`:
    * set `prefix = 'SST',`
  * Repeat the above steps for `jul-dec`
  * Submit the job again with:
    * `sbatch ungrib_cori.sl_year <year>`
  * When the job completes, make sure the `WPS_<year>_<months>` directories have the three-hourly files that look like `SST:<date>_<time>`

1. Generate the metgrid files:
  * Submit the job with:
    * `sbatch metgrid_cori.sl_year <year>`
  * When the job completes, make sure the `WPS_<year>_<months>` directories have the three-hourly files that look like `met_em.d01.<date>_<time>.nc`

1. Create the WRF inputs:
  * Copy the WRF folder to a year and month specific folder:
    * `cp -L -r $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>`
  * Copy the input and batch script to the new folder:
    * `cp namelist.create_wrf_input $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/namelist.input`
    * `cp run_real.sl $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/`
  * `cd $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>`
  * Update the `namelist.input` start and end times:
    * note that there is an extra week beyond the 6 month period
    * `start_year = <year>`
    * `start_month = 01` or `start_month = 07`
    * `end_year = <year>` or `end_year = <year + 1>`
    * `end_month = 07` or `end_month = 01`
    * `end_day = 06` or `end_day = 07`
    * `end_hour = 21` or `end_hour = 00`
  * Link the `.nc` files generated in the previous step:
    * `ln -s $SCRATCH/WRF_CLIMATE/WPS_<year>_<months>/met_em*.nc ./`
    * Also link the overlapping files from the subsequent time period (one week)
  * Load important modules:
    * You may need to unload some other modules first
    * `module load craype-mic-knl`
    * `module load cray-netcdf`
    * `module load impi`
  * Submit the job with:
    * `sbatch run_real.sl`
  * When the job completes, check the log files for errors and make sure the files `wrfbdy_d01`, `wrffdda_d01`, `wrfinput_d01`, and `wrflowinp_d01` exist in the folder
  * Repeat the above steps for the other set of <months>.

1. Download the GHG concentration data from https://esgf-node.llnl.gov/search/input4mips/:
  * On NERSC, run `module load globus-tools` to access the Globus utilities
  * Run the script `downloadGHGFiles.sh` to create a Globus task for downloading the time invariant files to `$SCRATCH/WRF_CLIMATE/GHG`
  * Convert these files to a format useable by WRF:
    * `module load matlab/R2020b`
    * `matlab -batch GHG_for_WRF_historical`
  * This should generate a data table at `$SCRATCH/WRF_CLIMATE/GHG/GHG.txt`
  * Copy this file to the WRFv4.2.1 code:
    * `cp $SCRATCH/WRF_CLIMATE/GHG/GHG.txt $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/CAMtr_volume_mixing_ratio`

1. Link the initial year and month data to the WRFv4.2.1 code:
  * `ln -sf $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/wrfbdy_d01 $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`
  * `ln -sf $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/wrffdda_d01 $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`
  * `ln -sf $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/wrflowinp_d01 $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`
  * `ln -sf $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/wrfinput_d01 $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`

1. Run WRF!
  * Update `$SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/namelist.input` with the start and end year, month, and day matching your files from the previous steps.
  * Copy the output fields file to the WRFv4.2.1 code:
    * `cp myoutfields.txt $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`
  * Copy the launch script to the WRFv4.2.1 code:
    * `cp run_wrf.sl $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`
  * Submit the job with:
    * `sbatch run_wrf.sl`
