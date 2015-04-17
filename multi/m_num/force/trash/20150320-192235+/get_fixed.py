import subprocess

fin_vt = open('m_num-m-force_vs_vt', 'r')
for line in fin_vt:
    results = line.split()
    var = int(results[0])
    vt = float(results[1])
    if var == 0:
        break
fin_vt.close()

fout_vt = open('m_num-f_vs_vt', 'w')
for i in range(21):
    fout_vt.write('{} {}\n'.format(i, vt))
fout_vt.close()

fin_ec = open('m_num-m-force_vs_ec', 'r')
for line in fin_ec:
    results = line.split()
    var = int(results[0])
    ec = float(results[1])
    if var == 0:
        break
fin_ec.close()

fout_ec = open('m_num-f_vs_ec', 'w')
for i in range(21):
    fout_ec.write('{} {}\n'.format(i, ec))
fout_ec.close()
