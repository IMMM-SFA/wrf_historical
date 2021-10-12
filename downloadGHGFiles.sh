#!/usr/bin/env bash

path=$SCRATCH/WRF_CLIMATE

uuid="415a6320-e49c-11e5-9798-22000b9da45e"

files=(
  "/user_pub_work/input4MIPs/CMIP6/CMIP/UoM/UoM-CMIP-1-2-0/atmos/yr/mole-fraction-of-carbon-dioxide-in-air/gr1-GMNHSH/v20160830/mole-fraction-of-carbon-dioxide-in-air_input4MIPs_GHGConcentrations_CMIP_UoM-CMIP-1-2-0_gr1-GMNHSH_0000-2014.nc"
 "/user_pub_work/input4MIPs/CMIP6/CMIP/UoM/UoM-CMIP-1-2-0/atmos/yr/mole-fraction-of-cfc12-in-air/gr1-GMNHSH/v20160830/mole-fraction-of-cfc12-in-air_input4MIPs_GHGConcentrations_CMIP_UoM-CMIP-1-2-0_gr1-GMNHSH_0000-2014.nc"
 "/user_pub_work/input4MIPs/CMIP6/CMIP/UoM/UoM-CMIP-1-2-0/atmos/yr/mole-fraction-of-methane-in-air/gr1-GMNHSH/v20160830/mole-fraction-of-methane-in-air_input4MIPs_GHGConcentrations_CMIP_UoM-CMIP-1-2-0_gr1-GMNHSH_0000-2014.nc"
 "/user_pub_work/input4MIPs/CMIP6/CMIP/UoM/UoM-CMIP-1-2-0/atmos/yr/mole-fraction-of-cfc11-in-air/gr1-GMNHSH/v20160830/mole-fraction-of-cfc11-in-air_input4MIPs_GHGConcentrations_CMIP_UoM-CMIP-1-2-0_gr1-GMNHSH_0000-2014.nc"
 "/user_pub_work/input4MIPs/CMIP6/CMIP/UoM/UoM-CMIP-1-2-0/atmos/yr/mole-fraction-of-nitrous-oxide-in-air/gr1-GMNHSH/v20160830/mole-fraction-of-nitrous-oxide-in-air_input4MIPs_GHGConcentrations_CMIP_UoM-CMIP-1-2-0_gr1-GMNHSH_0000-2014.nc"
#  "/user_pub_work/input4MIPs/CMIP6/ScenarioMIP/UoM/UoM-REMIND-MAGPIE-ssp585-1-2-1/atmos/yr/mole_fraction_of_nitrous_oxide_in_air/gr1-GMNHSH/v20181127/mole-fraction-of-nitrous-oxide-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc"
#  "/user_pub_work/input4MIPs/CMIP6/ScenarioMIP/UoM/UoM-REMIND-MAGPIE-ssp585-1-2-1/atmos/yr/mole_fraction_of_carbon_dioxide_in_air/gr1-GMNHSH/v20181127/mole-fraction-of-carbon-dioxide-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc"
#  "/user_pub_work/input4MIPs/CMIP6/ScenarioMIP/UoM/UoM-REMIND-MAGPIE-ssp585-1-2-1/atmos/yr/mole_fraction_of_cfc11_in_air/gr1-GMNHSH/v20181127/mole-fraction-of-cfc11-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc"
#  "/user_pub_work/input4MIPs/CMIP6/ScenarioMIP/UoM/UoM-REMIND-MAGPIE-ssp585-1-2-1/atmos/yr/mole_fraction_of_cfc12_in_air/gr1-GMNHSH/v20181127/mole-fraction-of-cfc12-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc"
#  "/user_pub_work/input4MIPs/CMIP6/ScenarioMIP/UoM/UoM-REMIND-MAGPIE-ssp585-1-2-1/atmos/yr/mole_fraction_of_methane_in_air/gr1-GMNHSH/v20181127/mole-fraction-of-methane-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc"
)

mkdir -p $path/GHG
printf "%s\n" "${files[@]}" > $path/GHG/transfer_file_list.txt

transfer_files.py -s $uuid -t dtn -i $path/GHG/transfer_file_list.txt -d $path/GHG
