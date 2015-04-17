#set terminal pdfcairo enhanced font "Times New Roman, 20"
#set output "20_m_num_vs_vt.pdf"
#set terminal postscript eps color solid font "Times New Roman, 20"
set terminal postscript eps color solid
#set terminal emf color solid enhanced font "Times New Roman, 20"
set output "100_f_num_vs_vt.eps"
#set terminal qt font "Times New Roman, 20"
#set xlabel "{/SimSun=20 �ն�����}"
set xlabel "Number of Fixed Nodes"
set xrange [40:200]
set xtics 20
set mxtics 1
#set ylabel "{/SimSun=20 ��Ч���ʱ���� (%)}"
set ylabel "Effective Monitoring Ratio (%)"
set yrange [10:90]
set ytics 20
set mytics 1
set format y "%.1f"
set grid
set key box
set key Left
#set key width 10
#set key spacing 10
set key left top at 51, 89
plot "f_num-m_vs_vt" w lp lt 1 lw 2 pt 5 ps 2 title "MT", "f_num-f_vs_vt" w lp lt 2 lw 2 pt 2 ps 2 title "FT", "f_num-fl_vs_vt" w lp lt 3 lw 2 pt 3 ps 2 title "MFT", "f_num-c_vs_vt" w lp lt 4 lw 2 pt 4 ps 2 title "CT"
set output
#!pdftops -eps 20_m_num_vs_vt.pdf