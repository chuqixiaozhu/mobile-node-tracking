#set terminal pdfcairo enhanced font "Times New Roman, 20"
#set output "20_m_num_vs_vt.pdf"
#set terminal postscript eps color solid font "Times New Roman, 20"
#set terminal postscript eps color solid
#set terminal emf color solid enhanced font "Times New Roman, 20"
set terminal emf color solid enhanced
set output "100_avg_mnode_per_target.emf"
#set terminal qt font "Times New Roman, 20"
#set xlabel "{/SimSun=20 空洞数量}"
set xlabel "Target Identity"
set xrange [1:5]
set xtics 1
set mxtics 1
#set ylabel "{/SimSun=20 有效监测时间率 (%)}"
set ylabel "Average of Mobile Node"
set yrange [0:2]
set ytics 0.5
set mytics 1
set format y "%.2f"
set grid
set key box
set key Left
#set key width 10
#set key spacing 10
#set key left top at 0.1, 79.5
plot "avg_mnode-force" w lp lt 1 lw 2 pt 2 ps 2 title "Force", "avg_mnode-direct" w lp lt 2 lw 2 pt 3 ps 2 title "Direct"
set output
#!pdftops -eps 20_m_num_vs_vt.pdf