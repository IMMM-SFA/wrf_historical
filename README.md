
1. Download and compile WRFv4.0.1 (which will be used for metgrid):
    1. `cd $SCRATCH/WRF_CLIMATE`
    1. `wget https://github.com/wrf-model/WRF/archive/refs/tags/v4.0.1.zip`
    1. `unzip v4.0.1.zip`
    1. `cd WRF-4.0.1`
    1. Load important modules:
        1. You may need to unload some other modules first
        1. `module load craype-haswell`
        1. `module load impi`
    1. `./configure`
        1. On NERSC, you first need to set the NETCDF environment variable: `export NETCDF=/opt/cray/pe/netcdf/default/INTEL/19.0`
        1. On NERSC, choose architecture 66 for Intel HSW (dmpar)
        1. Choose 1=basic
    1. `./compile wrf`
1. Download and compile WRFv4.2.1:
    1. `cd $SCRATCH/WRF_CLIMATE`
    1. `wget https://github.com/wrf-model/WRF/archive/refs/tags/v4.2.1.zip`
    1. `unzip v4.2.1.zip`
    1. `cd WRF-4.2.1`
    1. Load important modules:
        1. You may need to unload some other modules first
        1. `module load cray-netcdf`
        1. `export NETCDF=${NETCDF_DIR}`
        1. `module load cray-parallel-netcdf`
        1. `export PNETCDF=${PARALLEL_NETCDF_DIR}`
        1. `module load cray-hdf5`
        1. `export HDF5=${HDF5_DIR}`
        1. `module load craype-mic-knl`
        1. `module load impi`
        1. `module load png`
        1. `module load jasper`
        1. `export JASPERLIB=/global/common/cori/software/jasper/1.900.1/hsw/intel/lib`
        1. `export JASPERINC=/global/common/cori/software/jasper/1.900.1/hsw/intel/include`
    1. Update the max history fields value:
        1. Open the file `frame/module_domain.F` with an editor and search for `max_hst_mods = 200`
        1. Update the value from 200 to 2000
        1. Save the file
    1. `./configure`
        1. On NERSC, choose architecture 70 for INTEL KNL MIC (dmpar)
        1. Choose 1=basic
    1. Within the file `congigure.wrf` update the setting for BUILD_RRTMG_FAST:
        1. `-DBUILD_RRTMG_FAST=1`
    1. Compile WRF with:
        1. `./compile em_real`
    1. Copy the file `namelist.input` to the WRF directory:
        1. `cp namelist.input $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/namelist.input`
1. Download and compile the WRF Pre-processing System (WPS) Version 4.0.1:
    1. `cd $SCRATCH/WRF_CLIMATE`
    1. `wget https://github.com/wrf-model/WPS/archive/refs/tags/v4.0.1.zip`
    1. `unzip v4.0.1.zip`
    1. `cd WPS-4.0.1`
    1. Load important modules:
        1. You may need to unload some other modules first
        1. `module load craype-haswell`
        1. `module unload impi`
    1. `./configure`
        1. On NERSC, you first need to set the NETCDF environment variable: `export NETCDF=${NETCDF_DIR}`
        1. On NERSC, choose architecture 39: "Cray XC CLE/Linux x86_64, Intel compiler"
    1. Set the path to the WRF installation:
        1. In `configure.wps`, add a line around line 56 like: `WRF_DIR = ../WRF-4.2.1`
    1. `./compile`
1. Download the static WRF geographical data from https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html. All the relevant links are:
      1. https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
      1. https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
      1. https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
      1. https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
      1. https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
      1. https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
      1. https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
      1. https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
      1. https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
      1. https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
      1. https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
      1. Unpack all these files into the same directory and note the location; for this walkthrough let's say we put them at `$SCRATCH/WRF_CLIMATE/GEOGRAPHY`
1. Set the following options in the `$SCRATCH/WRF_CLIMATE/WPS-4.0.1/namelist.wps` file:
    1. `max_dom = 1,`
    1. `interval_seconds = 10800,`
    1. `e_we = 425,`
    1. `e_sn = 300,`
    1. `geog_data_res   = 'nlcd2011_9s+modis_fpar+modis_lai',`
    1. `dx = 12000,`
    1. `dy = 12000,`
    1. `map_proj = 'lambert'`,
    1. `ref_lat   =  40.0,`
    1. `ref_lon   = -97.0,`
    1. `truelat1  =  30.0,`
    1. `truelat2  =  45.0,`
    1. `stand_lon = -97.0,`
    1. `geog_data_path = '$SCRATCH/WRF_CLIMATE/GEOGRAPHY',` (replace with directory from step 3!)
    1. `fg_name = 'FILE', 'SST',`
    1. `constants_name = 'FIX:1979-01-01_00',`
1. Generate the grid file:
    1. Submit the job with:
        1. `sbatch geogrid_cori.sl`
    1. When the job completes, confirm that the file `geo_em.d01.nc` was created in the `WPS-4.0.1` directory and is about 25 MB
1. Download and process the time invariant ERA5 grib files:
    1. On NERSC, run `module load globus-tools` to access the Globus utilities
    1. Run the script `downloadInvariantFiles.sh` to create a Globus task for downloading the time invariant files to `$SCRATCH/WRF_CLIMATE/invariant`
    1. If you haven't used the Globus tools before, there will be a step to authorize NERSC to use your Globus account
    1. `cd $SCRATCH/WRF_CLIMATE/WPS-4.0.1`
    1. Link the invariant files:
        1. `./link_grib.csh $SCRATCH/WRF_CLIMATE/invariant/*grb`
    1. Link the ERA VTable:
        1. `ln -s ./ungrib/Variable_Tables/Vtable.ERA-interim.pl Vtable`
    1. In `namelist.wps`:
        1. update `prefix = 'FIX',`
        1. update `start_date = '1979-01-01_00:00:00',`
        1. update `end_date = '1979-01-01_00:00:00',`
    1. Submit the batch job to ungrib with `sbatch ungrib_cori.invariant.sl`
    1. When the job completes, you should see a file `FIX:1979-01-01_00`
    1. Delete the supporting file:
        1. `rm GRIBFILE.*`
1. Download the relevant ERA5 grib files for the year you want to simulate:
    1. On NERSC, run `module load globus-tools` to access the Globus utilities
    1. Run the script `createFileListForYear.sh <year>` to create a list of ERA5 files needed for that year, which will create `$SCRATCH/WRF_CLIMATE/<year>/transfer_jan-jun.txt` and `$SCRATCH/WRF_CLIMATE/<year>/transfer_jul-dec.txt`
    1. Download data for Jan-Jun of that year:
        1. `transfer_files.py -s 1e128d3c-852d-11e8-9546-0a6d4e044368 -t dtn -i $SCRATCH/WRF_CLIMATE/<year>/transfer_jan-jun.txt -d $SCRATCH/WRF_CLIMATE/<year>/jan-jun`
        1. This will create a Globus task which will eventually succeed and notify you by email
    1. Download data for Jul-Dec of that year:
        1. `transfer_files.py -s 1e128d3c-852d-11e8-9546-0a6d4e044368 -t dtn -i $SCRATCH/WRF_CLIMATE/<year>/transfer_jul-dec.txt -d $SCRATCH/WRF_CLIMATE/<year>/jul-dec`
        1. This will create a Globus task which will eventually succeed and notify you by email
1. Copy the entire `WPS-4.0.1` directory to a 6-month-specific directories:
    1. `cp -r $SCRATCH/WRF_CLIMATE/WPS-4.0.1 $SCRATCH/WRF_CLIMATE/WPS_<year>_jan-jun`
    1. `cp -r $SCRATCH/WRF_CLIMATE/WPS-4.0.1 $SCRATCH/WRF_CLIMATE/WPS_<year>_jul-dec`
1. Perform the first WPS preprocessing:
    1. `cd $SCRATCH/WRF_CLIMATE/WPS_<year>_jan-jun`
    1. Link the ERA5 forcing data for this 6 month period:
        1. `./link_grib.csh $SCRATCH/WRF_CLIMATE/<year>/jan-jun/*grb`
    1. Link the ERA VTable:
        1. `ln -sf ./ungrib/Variable_Tables/Vtable.ERA-interim.pl Vtable`
    1. Update the `namelist.wps`:
        1. set `prefix = 'FILE',`
        1. set `start_date = '<year>-01-01_00:00:00',`
        1. set `end_date = '<year>-06-30_21:00:00',`
    1. Repeat the above steps for `jul-dec`, making sure to update the start and end dates
    1. Submit the job with:
        1. `sbatch ungrib_cori.sl_year <year>`
    1. When the job completes, make sure the `WPS_<year>_<months>` directories have the three-hourly files that look like `FILE:<date>_<time>`
1. Perform the second WPS preprocessing: (TODO maybe not necessary)
    1. `cd $SCRATCH/WRF_CLIMATE/WPS_<year>_jan-jun`
    1. Link the SST VTable:
        1. `ln -sf ./ungrib/Variable_Tables/Vtable.SST Vtable`
    1. Update the `namelist.wps`:
        1. set `prefix = 'SST',`
    1. Repeat the above steps for `jul-dec`
    1. Submit the job again with:
        1. `sbatch ungrib_cori.sl_year <year>`
    1. When the job completes, make sure the `WPS_<year>_<months>` directories have the three-hourly files that look like `SST:<date>_<time>`
1. Generate the metgrid files:
    1. Submit the job with:
        1. `sbatch metgrid_cori.sl_year <year>`
    1. When the job completes, make sure the `WPS_<year>_<months>` directories have the three-hourly files that look like `met_em.d01.<date>_<time>.nc`
1. Create the WRF inputs:
    1. Copy the WRF folder to a year and month specific folder:
        1. `cp -L -r $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>`
    1. Copy the input and batch script to the new folder:
        1. `cp namelist.create_wrf_input $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/namelist.input`
        1. `cp run_real.sl $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/`
    1. `cd $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>`
    1. Update the `namelist.input` start and end times:
        1. note that there is an extra week beyond the 6 month period
        1. `start_year = <year>`
        1. `start_month = 01` or `start_month = 07`
        1. `end_year = <year>` or `end_year = <year + 1>`
        1. `end_month = 07` or `end_month = 01`
        1. `end_day = 06` or `end_day = 07`
        1. `end_hour = 21` or `end_hour = 00`
    1. Link the `.nc` files generated in the previous step:
        1. `ln -s $SCRATCH/WRF_CLIMATE/WPS_<year>_<months>/met_em*.nc ./`
        1. Also link the overlapping files from the subsequent time period (one week)
    1. Load important modules:
        1. You may need to unload some other modules first
        1. `module load craype-mic-knl`
        1. `module load cray-netcdf`
        1. `module load impi`
    1. Submit the job with:
        1. `sbatch run_real.sl`
    1. When the job completes, check the log files for errors and make sure the files `wrfbdy_d01`, `wrffdda_d01`, `wrfinput_d01`, and `wrflowinp_d01` exist in the folder
    1. Repeat the above steps for the other set of <months>.
1. Download the GHG concentration data from https://esgf-node.llnl.gov/search/input4mips/:
    1. On NERSC, run `module load globus-tools` to access the Globus utilities
    1. Run the script `downloadGHGFiles.sh` to create a Globus task for downloading the time invariant files to `$SCRATCH/WRF_CLIMATE/GHG`
    1. Convert these files to a format useable by WRF:
        1. `module load matlab/R2020b`
        1. `matlab -batch GHG_for_WRF_historical`
    1. This should generate a data table at `$SCRATCH/WRF_CLIMATE/GHG/GHG.txt`
    1. Copy this file to the WRFv4.2.1 code:
        1. `cp $SCRATCH/WRF_CLIMATE/GHG/GHG.txt $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/CAMtr_volume_mixing_ratio`
1. Link the initial year and month data to the WRFv4.2.1 code:
    1. `ln -sf $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/wrfbdy_d01 $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`
    1. `ln -sf $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/wrffdda_d01 $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`
    1. `ln -sf $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/wrflowinp_d01 $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`
    1. `ln -sf $SCRATCH/WRF_CLIMATE/WRF_input_<year>_<months>/wrfinput_d01 $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`
1. Run WRF!
    1. Update `$SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/namelist.input` with the start and end year, month, and day matching your files from the previous steps.
    1. Copy the output fields file to the WRFv4.2.1 code:
        1. `cp myoutfields.txt $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`
    1. Copy the launch script to the WRFv4.2.1 code:
        1. `cp run_wrf.sl $SCRATCH/WRF_CLIMATE/WRF-4.2.1/test/em_real/`
    1. Submit the job with:
        1. `sbatch run_wrf.sl`
    1. The output data will populate in this directory for both 1-hour resolution for a few variables, and 3-hour resolution for many variables.
1. For the full experiment, WRF must run for a year of warmup (1979). After each 6 months of input data has been run through WRF, the new data must be linked and WRF restarted from the latest restart file. See the file `s_restartV6` for techniques on automating the restart process and adapting the timestep when necessary.
