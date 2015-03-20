#! /usr/local/bin/python3
import datetime
import subprocess
import sys

# Do experiments many time
time = datetime.datetime.today()
time_fmt = '%Y%m%d-%H%M%S'
path = '20150316-221529'
# reuilt files are in 'path/'
result_file = path + '-result'

# Process the results
rf = open(result_file, 'r')
vt_file = open('m_num-m-direct_vs_vt', 'w')
ec_file = open('m_num-m-direct_vs_ec', 'w')
vt = dict()
ec = dict()
count = dict()
for line in rf:
    results = line.split()
    var = int(results[0])
    time = float(results[1])
    energy = float(results[2])
    if not (var in vt.keys()):
        vt[var] = 0.0
        ec[var] = 0.0
        count[var] = 0
    vt[var] += time
    ec[var] += energy
    count[var] += 1
vars = sorted(vt.keys())
for var in vars:
    #print('{0} {1} {2}'.format(var, vt[var]/count, ec[var]/count))
    vt_file.write('{0} {1:.2f}\n'.format(var, vt[var] / count[var]))
    ec_file.write('{0} {1:.2f}\n'.format(var, ec[var] / count[var]))
vt_file.close()
ec_file.close()
rf.close()
subprocess.call(['mv', result_file, path])
subprocess.call(['mv', vt_file.name, path])
subprocess.call(['mv', ec_file.name, path])
