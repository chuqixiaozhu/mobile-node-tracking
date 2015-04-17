#set terminal pdfcairo enhanced font "Times New Roman, 20"
#set output "20_hole_vs_vt.pdf"
#set terminal postscript eps color solid font "Times New Roman, 20"
set terminal postscript eps color solid
#set terminal emf color solid enhanced font "Times New Roman, 20"
set output "100_t_speed_vs_ec.eps"
#set terminal qt font "Times New Roman, 20"
#set xlabel "{/SimSun=20 空洞数量}"
set xlabel "Number of Fixed Nodes"
set xrange [40:200]
set xtics 20
set mxtics 1
#set ylabel "{/SimSun=20 有效监测时间率 (%)}"
set ylabel "Total Energy Consumption (J)"
set yrange [1:3]
set ytics 0.5
set mytics 1
set format y "%.1f"
set grid
set key box
set key Left
#set key width 10
#set key spacing 10
set key right bottom at 6.95, 0.105
plot "f_num-m-force_vs_ec" u 1:($2/1000.0) w lp lt 1 lw 2 pt 5 ps 2 title "Force", "f_num-f_vs_ec" u 1:($2/1000.0) w lp lt 2 lw 2 pt 2 ps 2 title "FT"
set output
#!pdftops -eps 20_hole_vs_vt.pdf