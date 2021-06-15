

1. Download and compile the WRF Pre-processing System Version 4.0.1:
  * `wget https://github.com/wrf-model/WPS/archive/refs/tags/v4.0.1.zip`
  * `unzip v4.0.1.zip`
  * `cd WPS-4.0.1`
  * `./configure`
    * On NERSC, you need to set the NETCDF environment variable: `export NETCDF=/opt/cray/pe/netcdf/default/INTEL/19.0`
    * On NERSC, choose architecture 39: "Cray XC CLE/Linux x86_64, Intel compiler"
  * `./compile`

2. Download the static WRF geographical data from https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html. All the relevant links are:
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

3. Set the options in the `WPS-4.0.1/namelist.wps` file:
  * `max_dom = 1,`
  * `interval_seconds = 10800,`
  * `e_we = 425,`
  * `e_sn = 300,`
  * `geog_data_res = 'nlcd2011_9s+modis_fpar+modis_lai+NUDAPT44_1km','nlcd2011_9s+modis_fpar+modis_lai+NUDAPT44_1km','nlcd2011_9s+modis_fpar+modis_lai+NUDAPT44_1km','nlcd2011_9s+modis_fpar+modis_lai+NUDAPT44_1km',`
  * `dx = 12000,`
  * `dy = 12000,`
  * map_proj = 'lambert',
  * `ref_lat   =  40.0,`
  * `ref_lon   = -97.0,`
  * `truelat1  =  30.0,`
  * `truelat2  =  45.0,`
  * `stand_lon = -97.0,`
  * `geog_data_path = '$SCRATCH/WRF_CLIMATE/GEOGRAPHY'` (replace with directory from step 3!)
  * `fg_name = 'FILE', 'SST'`
  * `constants_name = 'FIX:1979-01-01_00'`

4. Download the relevant ERA5 grib files for the year you want to simulate:
  * On NERSC, can use the `module load globus-tools` to download with globus
  * Run the script `createFileList.sh <year>` to create a list of ERA5 files needed for that year, which will create `$SCRATCH/WRF_CLIMATE/<year>/transfer_jan-jun.txt` and `$SCRATCH/WRF_CLIMATE/<year>/transfer_jul-dec.txt`
  * To download data for Jan-Jun of that year, run `transfer_files.py -s 1e128d3c-852d-11e8-9546-0a6d4e044368 -t dtn -i $SCRATCH/WRF_CLIMATE/<year>/transfer_jan-jun.txt -d $SCRATCH/WRF_CLIMATE/<year>/jan-jun`
  * This will create a globus task which will eventually succeed

5. Copy the entire `WPS-4.0.1` directory to a 6-month-specific directory and configure the 6-month-specific options:
  * For example `cp -r WPS-4.0.1 WPS_<year>_jan-jun`
  * Repeat for `jul-dec`

6. Perform the WPS preprocessing:
  * `cd WPS_<year>_jan-jun`
  * Set the prefix in `namelist.wps` to 'FIX':
    * `prefix = 'FIX'`
  * 
  *
  * Link the ERA5 forcing data for this 6 month period:
    * `./link_grib.csh $SCRATCH/WRF_CLIMATE/<year>/jan-jun/*grb`
  * Update the start and end date in the `WPS_<year>_jan-jun/namelist.wps`:
      * `start_date = '<year>-01-01_00:00:00',`
      * `end_date = '<year>-06-30_21:00:00',`
