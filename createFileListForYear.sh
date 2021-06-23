#!/usr/bin/env bash

year=$1
path=$SCRATCH/WRF_CLIMATE

declare -a pl_files=(
  "129_z.ll025sc"
  "130_t.ll025sc"
  "131_u.ll025uv"
  "132_v.ll025uv"
  "157_r.ll025sc"
)

declare -a sfc_files=(
  "031_ci.ll025sc"
  "033_rsn.ll025sc"
  "034_sstk.ll025sc"
  "039_swvl1.ll025sc"
  "040_swvl2.ll025sc"
  "041_swvl3.ll025sc"
  "042_swvl4.ll025sc"
  "134_sp.ll025sc"
  "139_stl1.ll025sc"
  "141_sd.ll025sc"
  "151_msl.ll025sc"
  "165_10u.ll025sc"
  "166_10v.ll025sc"
  "167_2t.ll025sc"
  "168_2d.ll025sc"
  "170_stl2.ll025sc"
  "183_stl3.ll025sc"
  "235_skt.ll025sc"
  "236_stl4.ll025sc"
)

mkdir -p $path/$year/jan-jun
mkdir -p $path/$year/jul-dec
for grb in "${pl_files[@]}"
do
  d=$year-01-01
  while [ "$d" != $year-07-01 ]
  do
    ym=$(date -d $d +%Y%m)
    ymd=$(date -d $d +%Y%m%d)
    echo "/ds633.0/e5.oper.an.pl/$ym/e5.oper.an.pl.128_$grb.${ymd}00_${ymd}23.grb" >> $path/$year/transfer_jan-jun.txt
    d=$(date -I -d "$d + 1 day")
  done
  while [ "$d" != $year-12-31 ]
  do
    ym=$(date -d $d +%Y%m)
    ymd=$(date -d $d +%Y%m%d)
    echo "/ds633.0/e5.oper.an.pl/$ym/e5.oper.an.pl.128_$grb.${ymd}00_${ymd}23.grb" >> $path/$year/transfer_jul-dec.txt
    d=$(date -I -d "$d + 1 day")
  done
  echo "/ds633.0/e5.oper.an.pl/$ym/e5.oper.an.pl.128_$grb.${ymd}00_${ymd}23.grb" >> $path/$year/transfer_jul-dec.txt
done
for grb in "${sfc_files[@]}"
do
  d=$year-01-01
  while [ "$d" != $year-07-01 ]
  do
    ym=$(date -d $d +%Y%m)
    start=$(date -d $d +%Y%m%d)
    d=$(date -I -d "$d + 1 month")
    d=$(date -I -d "$d - 1 day")
    end=$(date -d $d +%Y%m%d)
    echo "/ds633.0/e5.oper.an.sfc/$ym/e5.oper.an.sfc.128_$grb.${start}00_${end}23.grb" >> $path/$year/transfer_jan-jun.txt
    d=$(date -I -d "$d + 1 day")
  done
  while [ "$d" != $year-12-01 ]
  do
    ym=$(date -d $d +%Y%m)
    start=$(date -d $d +%Y%m%d)
    d=$(date -I -d "$d + 1 month")
    d=$(date -I -d "$d - 1 day")
    end=$(date -d $d +%Y%m%d)
    echo "/ds633.0/e5.oper.an.sfc/$ym/e5.oper.an.sfc.128_$grb.${start}00_${end}23.grb" >> $path/$year/transfer_jul-dec.txt
    d=$(date -I -d "$d + 1 day")
  done
  start=$(date -d $d +%Y%m%d)
  d=$(date -I -d "$d + 1 month")
  d=$(date -I -d "$d - 1 day")
  end=$(date -d $d +%Y%m%d)
  echo "/ds633.0/e5.oper.an.sfc/$ym/e5.oper.an.sfc.128_$grb.${start}00_${end}23.grb" >> $path/$year/transfer_jul-dec.txt
done

transfer_files.py -s 1e128d3c-852d-11e8-9546-0a6d4e044368 -t dtn -i $path/$year/transfer_jan-jun.txt -d $path/$year/jan-jun
transfer_files.py -s 1e128d3c-852d-11e8-9546-0a6d4e044368 -t dtn -i $path/$year/transfer_jul-dec.txt -d $path/$year/jul-dec
