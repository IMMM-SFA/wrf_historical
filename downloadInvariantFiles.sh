#!/usr/bin/env bash

path=$SCRATCH/WRF_CLIMATE

invariant="/ds633.0/e5.oper.invariant/197901/e5.oper.invariant.128_172_lsm.ll025sc.1979010100_1979010100.grb"

mkdir -p $path/invariant
echo $invariant > $path/invariant/transfer_file_list.txt

transfer_files.py -s 1e128d3c-852d-11e8-9546-0a6d4e044368 -t dtn -i $path/invariant/transfer_file_list.txt -d $path/invariant
