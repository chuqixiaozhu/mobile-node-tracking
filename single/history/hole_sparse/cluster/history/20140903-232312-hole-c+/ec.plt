set terminal pdfcairo enhanced font "Times New Roman, 8"
set output "20_hole_vs_ec.pdf"
set xlabel "{/SimSun=8 空洞数量}"
set xrange [1:5]
set xtics 1
set mxtics 1
set ylabel "{/SimSun=8 能量消耗 (J)}"
set yrange [0:0.8]
set ytics 0.2
set mytics 2
#set format y "%.1f%%"
set grid
set key box
set key Left
#set key width 1
#set key spacing 10
set key left bottom at 1.04, 0.015
plot "hole-m_vs_ec" u 1:($2/1000.0) w lp lt 1 lw 1 pt 2 ps 1 title "MT", "hole-f_vs_ec" u 1:($2/1000.0) w lp lt 2 lw 1 pt 3 ps 1 title "FT", "hole-c_vs_ec" u 1:($2/1000.0) w lp lt 3 lw 1 pt 4 ps 1 title "CT"
set output
!pdftops -eps 20_hole_vs_ec.pdf