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
for i in range(count):
    #for r_force in range(0, 105, 5):
    subprocess.call(['ns', 'mobile.tcl', result_file])

# Process the results
rf = open(result_file, 'r')
#vt_file = open('r_force-m-force_vs_vt', 'w')
#ec_file = open('r_force-m-force_vs_ec', 'w')
avg_mnode_file = open('avg_mnode-direct', 'w')
#vt = dict()
target_avg = dict()
#ec = dict()
for line in rf:
    results = line.split()
    ntarget = len(results)
    for i in range(ntarget):
        if i not in target_avg.keys():
            target_avg[i] = 0.0
        target_avg[i] += float(results[i])
#    var = int(results[0])
#    time = float(results[1])
#    energy = float(results[2])
#    if not (var in vt.keys()):
#        vt[var] = 0.0
#        ec[var] = 0.0
#    vt[var] += time
#    ec[var] += energy
#vars = sorted(vt.keys())
#for var in vars:
#    #print('{0} {1} {2}'.format(var, vt[var]/count, ec[var]/count))
#    vt_file.write('{0} {1:.2f}\n'.format(var, vt[var] / count))
#    ec_file.write('{0} {1:.2f}\n'.format(var, ec[var] / count))
for i in range(ntarget):
    avg_mnode_file.write('{0} {1:.2f}\n'.format(i + 1, target_avg[i] / count))
#vt_file.close()
#ec_file.close()
avg_mnode_file.close()
rf.close()
subprocess.call(['mv', result_file, path])
subprocess.call(['mv', avg_mnode_file.name, path])
#subprocess.call(['mv', vt_file.name, path])
#subprocess.call(['mv', ec_file.name, path])
