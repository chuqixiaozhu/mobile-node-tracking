#set terminal postscript eps color "Times-Roman"
#set output "20_hole-c_vs_ec.eps"
set xlabel "Number of Holes"
set xtics 1, 1, 5
set ylabel "Energy Consumption"
set yrange [10:16]
set ytics 10, 1
set format y "%.1f"
plot "hole-c_vs_ec" using 1:($2/1000.0) with linespoints title "Cluster"
set output