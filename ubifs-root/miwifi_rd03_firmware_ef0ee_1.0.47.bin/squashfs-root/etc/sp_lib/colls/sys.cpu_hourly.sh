#!/bin/ash

data=$(grep 'cpu ' /proc/stat;sleep 1;grep 'cpu ' /proc/stat)
echo "$data"|awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) / (t-t1); }'
