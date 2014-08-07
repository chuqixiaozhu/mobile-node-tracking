#! /bin/bash
path="$(date +%Y%m%d-%H%M%S)-f_num-m"
result_file="${path}/${path}-result"
#file_speed="${path}/${path}-result_target_speed"
mkdir $path
#cp -u process-num.awk ${path}
#ns mobile.tcl 100 100 100 10 3 ${result_file} ${file_speed}
if [ x$1 != x ]
then
    count=$1
else
    count=20
fi
for nfnode in $(seq 330 20 350)
do
    for i in $(seq 1 $count)
    do
        #echo ""
        #now_time="$(date +%H%M%S)"
        ns mobile.tcl 100 100 ${nfnode} 10 3 ${result_file}
    done
done
#cd $path
awk -f process-f_num-m.awk ${result_file} > ${path}/${path}-avg
