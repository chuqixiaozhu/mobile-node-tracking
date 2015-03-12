#set terminal pdfcairo enhanced font "Times New Roman, 20"
#set output "20_m_num_vs_vt.pdf"
#set terminal postscript eps color solid font "Times New Roman, 20"
set terminal postscript eps color solid
#set terminal emf color solid enhanced font "Times New Roman, 20"
set output "50_target_num-multi_vs_vt.eps"
#set terminal qt font "Times New Roman, 20"
#set xlabel "{/SimSun=20 空洞数量}"
set xlabel "Weight"
set xrange [100:1000]
set xtics 50
set mxtics 1
#set ylabel "{/SimSun=20 有效监测时间率 (%)}"
set ylabel "Average Effective Monitoring Ratio (%)"
set yrange [50:60]
set ytics 2
set mytics 1
set format y "%.1f"
set grid
set key box
set key Left
#set key width 10
#set key spacing 10
#set key left top at 0.1, 79.5
plot "r_force-m-force_vs_vt" w lp lt 1 lw 2 pt 5 ps 2 title "Force"
set output
#!pdftops -eps 20_m_num_vs_vt.pdf