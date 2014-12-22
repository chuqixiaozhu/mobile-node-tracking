#! /bin/bash
result="f_vs_vt"
data="47.0"
for i in $(seq 0 20)
do
    echo  "${i} ${data}" >> ${result}
done