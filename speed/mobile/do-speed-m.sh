#! /bin/bash
path="$(date +%Y%m%d-%H%M%S)-speed-m"
result_file="${path}/${path}-result"
#file_speed="${path}/${path}-result_target_speed"
mkdir $path
#cp -u process-speed.awk ${path}
#ns mobile.tcl 100 100 100 10 3 ${result_file} ${file_speed}
if [ x$1 != x ]
then
    count=$1
else
    count=20
fi
for speed in $(seq 1 10)
do
    for i in $(seq 1 $count)
    do
        #echo ""
        #now_time="$(date +%H%M%S)"
        ns mobile.tcl 100 100 100 20 ${speed} ${result_file}
        #ns mobile.tcl 100 100 100 0 ${speed} ${result_file}
    done
done
#cd $path
awk -f process-speed-m.awk ${result_file} > ${path}/${path}-avg
