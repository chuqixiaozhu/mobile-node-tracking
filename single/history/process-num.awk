BEGIN {
    max_nmnode = 0;
}
{
    nmnode = $1;
    valid_time = $3;
    energy_consumption = $4;

    if (max_nmnode < nmnode) {
        max_nmnode = nmnode;
    }

    sum_valid_time[nmnode] += valid_time;
    sum_energy_consumption[nmnode] += energy_consumption;
    ++count[nmnode];
}
END {
    for (i = 0; i < max_nmnode + 1; ++i) {
        avg_valid_time[i] = 1.0 * sum_valid_time[i] / count[i];
        avg_energy_consumption[i] = 1.0 * sum_energy_consumption[i] / count[i];
    }
    for (i = 0; i < max_nmnode + 1; ++i) {
        printf("%3d %11f %3d %15f\n", i, avg_valid_time[i], i, avg_energy_consumption[i]);
    }
}
