#set terminal pdfcairo enhanced font "Times New Roman, 20"
#set output "20_hole_vs_vt.pdf"
#set terminal postscript eps color solid font "Times New Roman, 20"
set terminal postscript eps color solid
#set terminal emf color solid enhanced font "Times New Roman, 20"
set output "10_m_num-multi_vs_ec.eps"
#set terminal qt font "Times New Roman, 20"
#set xlabel "{/SimSun=20 �ն�����}"
set xlabel "Number of Mobile Nodes"
set xrange [0:20]
set xtics 1
set mxtics 1
#set ylabel "{/SimSun=20 ��Ч���ʱ���� (%)}"
set ylabel "Energy Consumption (J)"
set yrange [0.5:1.0]
set ytics 0.1
set mytics 1
set format y "%.1f"
set grid
set key box
set key Left
#set key width 10
#set key spacing 10
#set key right bottom at 6.95, 0.105
#plot "t_speed-m_vs_ec" u 1:($2/1000.0) w lp lt 1 lw 2 pt 5 ps 2 title "MT", "t_speed-f_vs_ec" u 1:($2/1000.0) w lp lt 2 lw 2 pt 2 ps 2 title "FT", "t_speed-fl_vs_ec" u 1:($2/1000.0) w lp lt 3 lw 2 pt 3 ps 2 title "MFT", "t_speed-c_vs_ec" u 1:($2/1000.0) w lp lt 4 lw 2 pt 4 ps 2 title "CT"
plot "m_num-m_vs_ec" u 1:($2/1000.0) w lp lt 1 lw 2 pt 5 ps 2 title "MT"
set output
#!pdftops -eps 20_hole_vs_vt.pdf