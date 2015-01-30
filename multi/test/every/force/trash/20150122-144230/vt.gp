#set terminal pdfcairo enhanced font "Times New Roman, 20"
#set output "20_m_num_vs_vt.pdf"
#set terminal postscript eps color solid font "Times New Roman, 20"
set terminal postscript eps color solid
#set terminal emf color solid enhanced font "Times New Roman, 20"
set output "100_avg_mnode_per_target.eps"
#set terminal qt font "Times New Roman, 20"
#set xlabel "{/SimSun=20 空洞数量}"
set xlabel "Target Identity"
set xrange [1:5]
set xtics 1
set mxtics 1
#set ylabel "{/SimSun=20 有效监测时间率 (%)}"
set ylabel "Average of Mobile Node"
set yrange [0.5:1.5]
set ytics 0.1
set mytics 1
set format y "%.2f"
set grid
set key box
set key Left
#set key width 10
#set key spacing 10
#set key left top at 0.1, 79.5
plot "avg_mnode-force-10-18" w lp lt 1 lw 2 pt 2 ps 2 title "Force: 1/1.8", "avg_mnode-force-10-75" w lp lt 2 lw 2 pt 3 ps 2 title "Force: 1/7.5", "avg_mnode-force-30-10" w lp lt 3 lw 2 pt 4 ps 2 title "Force: 3/1", "avg_mnode-direct" w lp lt 4 lw 2 pt 5 ps 2 title "Direct"
set output
#!pdftops -eps 20_m_num_vs_vt.pdf