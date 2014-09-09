set terminal pdfcairo enhanced font "Times New Roman, 8"
set output "20_hole_vs_vt.pdf"
set xlabel "{/SimSun=8 空洞数量}"
set xrange [1:5]
set xtics 1
set mxtics 1
set ylabel "{/SimSun=8 有效监测时间率 (%)}"
set yrange [30:80]
set ytics 10
set mytics 1
set format y "%.1f%%"
set grid
set key box
set key Left
#set key width 10
#set key spacing 10
set key left bottom at 1.05, 61.5
plot "hole-m_vs_vt" w lp lt 1 lw 1 pt 2 ps 1 title "MT", "hole-f_vs_vt" w lp lt 2 lw 1 pt 3 ps 1 title "FT", "hole-c_vs_vt" w lp lt 3 lw 1 pt 4 ps 1 title "CT"
set output
!pdftops -eps 20_hole_vs_vt.pdf