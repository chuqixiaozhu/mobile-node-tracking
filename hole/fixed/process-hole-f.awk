BEGIN {
    max_hole_num = 0;
}
{
    hole_num = $1;
    valid_time = $2;
    energy_consumption = $3;

    if (max_hole_num < hole_num) {
        max_hole_num = hole_num;
    }

    sum_valid_time[hole_num] += valid_time;
    sum_energy_consumption[hole_num] += energy_consumption;
    ++count[hole_num];
}
END {
    for (i = 1; i < max_hole_num + 1; ++i) {
        avg_valid_time[i] = 1.0 * sum_valid_time[i] / count[i];
        avg_energy_consumption[i] = 1.0 * sum_energy_consumption[i] / count[i];
    }
    for (i = 1; i < max_hole_num + 1; ++i) {
        printf("%d %5.1f%% %15f\n", i, avg_valid_time[i] / 10, avg_energy_consumption[i]);
    }
}
