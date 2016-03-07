#set terminal pdfcairo enhanced font "Times New Roman, 20"
#set output "20_hole_vs_vt.pdf"
#set terminal postscript eps color solid font "Times New Roman, 20"
set terminal postscript eps color solid font ", 24"
#set terminal emf color solid enhanced font "Times New Roman, 20"
set output "100_m_num-multi_vs_ec.eps"
#set terminal qt font "Times New Roman, 20"
#set xlabel "{/SimSun=20 空洞数量}"
set xlabel "Number of Mobile Nodes"
set xrange [0.1:0.9]
set xtics 0.1
set mxtics 1
#set ylabel "{/SimSun=20 有效监测时间率 (%)}"
set ylabel "Energy Consumption (J)"
set yrange [0.7:0.8]
set ytics 0.02
set mytics 1
set format y "%.2f"
set grid
set key box
set key Left
#set key width 10
#set key spacing 10
#set key left bottom at 0.3, 0.11
plot "m_num-m-force_vs_ec" u 1:($2/1000.0) w lp lt 1 lw 2 pt 5 ps 2 title "MTTA"#,\
     "m_num-m_vs_ec" u 1:($2/1000.0) w lp lt 2 lw 2 pt 2 ps 2 title "Accurate"#,\
     "m_num-fl_vs_ec" u 1:($2/1000.0) w lp lt 3 lw 2 pt 3 ps 2 title "MFT",\
     "m_num-c_vs_ec" u 1:($2/1000.0) w lp lt 4 lw 2 pt 4 ps 2 title "CT"
set output
#!pdftops -eps 20_hole_vs_vt.pdf