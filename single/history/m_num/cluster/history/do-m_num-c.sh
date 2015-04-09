#! /bin/bash
path="$(date +%Y%m%d-%H%M%S)-m_num-c"
result_file="${path}/${path}-result"
filen="${path}-result"
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
#for target_radius_time in $(seq 10 30)
#do
    for i in $(seq 1 $count)
    do
        #echo ""
        #now_time="$(date +%H%M%S)"
        ns mobile.tcl 100 100 100 0 3 ${result_file} 5
    done
#done
#cd $path
#awk -f process-num.awk ${result_file} > ${path}/${path}-avg
cp -u process-m_num-c.awk ${path}
cd ${path}
awk -f process-m_num-c.awk ${filen}
#awk -f process-num.awk ${result_file}
