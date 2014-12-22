#! /usr/local/bin/python3
import datetime
import subprocess
import sys

# Do experiments many time
time = datetime.datetime.today()
time_fmt = '%Y%m%d-%H%M%S'
path = time.strftime(time_fmt)
# reuilt files are in 'path/'
result_file = path + '-result'
subprocess.call(['mkdir', path])
argvs = sys.argv
if len(argvs) <= 1:
    count = 2
else:
    count = int(argvs[1])
for fnode_num in range(50, 201, 10):
    for i in range(count):
        subprocess.call(['ns', 'mobile.tcl', str(fnode_num), result_file])

# Process the results
rf = open(result_file, 'r')
vt_file = open('f_num-f_vs_vt', 'w')
ec_file = open('f_num-f_vs_ec', 'w')
vt = dict()
ec = dict()
for line in rf:
    results = line.split()
    var = int(results[0])
    time = float(results[1])
    energy = float(results[2])
    if not (var in vt.keys()):
        vt[var] = 0.0
        ec[var] = 0.0
    vt[var] += time
    ec[var] += energy
vars = sorted(vt.keys())
for var in vars:
    #print('{0} {1} {2}'.format(var, vt[var]/count, ec[var]/count))
    vt_file.write('{0} {1}\n'.format(var, vt[var] / count))
    ec_file.write('{0} {1}\n'.format(var, ec[var] / count))
vt_file.close()
ec_file.close()
rf.close()
subprocess.call(['mv', result_file, path])
subprocess.call(['mv', vt_file.name, path])
subprocess.call(['mv', ec_file.name, path])