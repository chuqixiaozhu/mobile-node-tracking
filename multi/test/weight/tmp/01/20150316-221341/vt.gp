#set terminal pdfcairo enhanced font "Times New Roman, 20"
#set output "20_m_num_vs_vt.pdf"
#set terminal postscript eps color solid font "Times New Roman, 20"
set terminal postscript eps color solid
#set terminal emf color solid enhanced font "Times New Roman, 20"
set output "100_m_num-multi_vs_vt.eps"
#set terminal qt font "Times New Roman, 20"
#set xlabel "{/SimSun=20 空洞数量}"
set xlabel "Number of Mobile Nodes"
set xrange [0:20]
set xtics 5
set mxtics 5
#set ylabel "{/SimSun=20 有效监测时间率 (%)}"
set ylabel "Average Effective Monitoring Ratio (%)"
set yrange [40:70]
set ytics 5
set mytics 1
set format y "%.1f"
set grid
set key box
set key Left
#set key width 10
#set key spacing 10
set key left top at 0.2, 69.5
plot \
     "m_num-m-force-05_vs_vt" w lp lt 5 lw 2 pt 6 ps 2 title "Force-05", \
     "m_num-m-force-09_vs_vt" w lp lt 9 lw 2 pt 10 ps 2 title "Force-09", \
     "m_num-m-direct_vs_vt" w lp lt 11 lw 2 pt 11 ps 2 title "Direct"
     #"m_num-m-force-01_vs_vt" w lp lt 1 lw 2 pt 2 ps 2 title "Force-01", \
     #"m_num-m-force-02_vs_vt" w lp lt 2 lw 2 pt 3 ps 2 title "Force-02", \
     "m_num-m-force-03_vs_vt" w lp lt 3 lw 2 pt 4 ps 2 title "Force-03", \
     #"m_num-m-force-04_vs_vt" w lp lt 4 lw 2 pt 5 ps 2 title "Force-04", \
     #"m_num-m-force-06_vs_vt" w lp lt 6 lw 2 pt 7 ps 2 title "Force-06", \
     "m_num-m-force-07_vs_vt" w lp lt 7 lw 2 pt 8 ps 2 title "Force-07", \
     "m_num-m-force-08_vs_vt" w lp lt 8 lw 2 pt 9 ps 2 title "Force-08", \
set output
#!pdftops -eps 20_m_num_vs_vt.pdf