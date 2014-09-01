#set terminal postscript eps color solid enhanced "SimSun" 18
#set output "20_hole-c_vs_vt.eps"
set term pdfcairo enhanced font "Times New Roman, 10"
set output "20_hole-c_vs_vt.pdf"
set xlabel "{/SimSun=10 空洞数}"
#set xlabel "空洞数"
set xrange [1:5]
set xtics 1
#set y2tics
set ylabel "Effective Monitoring Time"
set yrange [50:90]
set ytics 10
set mytics 5
set format y "%.1f%%"
set grid
set key box
set key left bottom at 1.1, 52
plot "hole-c_vs_vt" w lp lt 1 lw 1 pt 2 ps 1 title "Cluster", "test" w lp lt 2 lw 1 pt 3 ps 1 title "test"
set output
!pdftops -eps 20_hole-c_vs_vt.pdf