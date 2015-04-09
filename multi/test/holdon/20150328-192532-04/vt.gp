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
#set key left top at 0.1, 79.5
plot "m_num-m-force_vs_vt" w lp lt 1 lw 2 pt 5 ps 2 title "Force", "m_num-m-direct_vs_vt" w lp lt 2 lw 2 pt 2 ps 2 title "Direct"
set output
#!pdftops -eps 20_m_num_vs_vt.pdf