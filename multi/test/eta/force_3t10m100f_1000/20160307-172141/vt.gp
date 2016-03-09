#set terminal pdfcairo enhanced font "Times New Roman, 20"
#set output "20_m_num_vs_vt.pdf"
#set terminal postscript eps color solid font "Times New Roman, 20"
set terminal postscript eps color solid enhanced font ", 24"
#set terminal emf color solid enhanced font "Times New Roman, 20"
set output "100_m_num-multi_vs_vt.eps"
#set terminal qt font "Times New Roman, 20"
#set xlabel "{/SimSun=20 空洞数量}"
set xlabel "Value of {/Symbol-Oblique h}"
set xrange [0.1:0.9]
set xtics 0.1
set mxtics 0
#set ylabel "{/SimSun=20 有效监测时间率 (%)}"
set ylabel "Average Effective Monitoring Ratio (%)"
set yrange [60:64]
set ytics 1
set mytics 1
set format y "%.1f"
set grid
set key box
set key Left
#set key width 10
#set key spacing 10
#set key left bottom at 0.2, 30.5
plot "m_num-m-force_vs_vt" w lp lt 1 lw 2 pt 5 ps 2 title "Force"#,\
     "m_num-f_vs_vt" w lp lt 2 lw 2 pt 2 ps 2 title "FT",\
     "m_num-m-fl_vs_vt" w lp lt 4 lw 2 pt 3 ps 2 title "Fill",\
     "m_num-c_vs_vt" w lp lt 3 lw 2 pt 4 ps 2 title "CT"
set output
#!pdftops -eps 20_m_num_vs_vt.pdf