clc
close all
clear
%%
vardata_time_co2 = ncread('mole-fraction-of-carbon-dioxide-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'time');
T_co2 = datetime(1850,1,1) + days(vardata_time_co2);
T_co2.Format = 'yyyy';
%%
vardata_time_n2o = ncread('mole-fraction-of-nitrous-oxide-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'time');
T_n2o = datetime(1850,1,1) + days(vardata_time_n2o);
T_n2o.Format = 'yyyy';
%%
vardata_time_methane = ncread('mole-fraction-of-methane-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'time');
T_methane = datetime(1850,1,1) + days(vardata_time_methane);
T_methane.Format = 'yyyy';
%%
vardata_time_cfc11 = ncread('mole-fraction-of-cfc11-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'time');
T_cfc11 = datetime(1850,1,1) + days(vardata_time_cfc11);
T_cfc11.Format = 'yyyy';
%%
vardata_time_cfc12 = ncread('mole-fraction-of-cfc12-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'time');
T_cfc12 = datetime(1850,1,1) + days(vardata_time_cfc12);
T_cfc12.Format = 'yyyy';
%%
vardata_sector_co2 = ncread('mole-fraction-of-carbon-dioxide-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'sector');
%%
vardata_sector_n2o = ncread('mole-fraction-of-nitrous-oxide-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'sector');
%%
vardata_sector_methane = ncread('mole-fraction-of-methane-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'sector');
%%
vardata_sector_cfc11 = ncread('mole-fraction-of-cfc11-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'sector');
%%
vardata_sector_cfc12 = ncread('mole-fraction-of-cfc12-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'sector');
%%
vardata_co2 = ncread('mole-fraction-of-carbon-dioxide-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'mole_fraction_of_carbon_dioxide_in_air');
%%
vardata_n2o = ncread('mole-fraction-of-nitrous-oxide-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'mole_fraction_of_nitrous_oxide_in_air');
%%
vardata_methane = ncread('mole-fraction-of-methane-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'mole_fraction_of_methane_in_air');
%%
vardata_cfc11 = ncread('mole-fraction-of-cfc11-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'mole_fraction_of_cfc11_in_air');
%%
vardata_cfc12 = ncread('mole-fraction-of-cfc12-in-air_input4MIPs_GHGConcentrations_ScenarioMIP_UoM-REMIND-MAGPIE-ssp585-1-2-1_gr1-GMNHSH_2015-2500.nc'...
    ,'mole_fraction_of_cfc12_in_air');
%%
for k=1:length(T_co2)
    year_k=T_co2(k,1);
    co2_k=vardata_co2(2,k);
    n2o_k=vardata_n2o(2,k);
    methane_k=vardata_methane(2,k);
    cfc11_k=vardata_cfc11(2,k);
    cfc12_k=vardata_cfc12(2,k);
    fprintf('%s  %.3f    %.3f   %.3f    %.3f    %.3f\n',year_k, co2_k, n2o_k, methane_k, cfc11_k, cfc12_k);
end