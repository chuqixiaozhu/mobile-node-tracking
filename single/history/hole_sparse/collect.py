import sys
import subprocess
import datetime

paths = ['cluster', 'fill', 'fixed', 'mobile']
time = datetime.datetime.today()
time_fmt = '%Y%m%d-%H%M%S'
path = time.strftime(time_fmt)

if len(sys.argv) <= 1:
    repeat = 1
    count = 10
else:
    repeat = int(sys.argv[1])
    count = int(sys.argv[2])
for i in range(repeat):
    for p in paths:
        subprocess.call([p + '/process.py', str(count)])
