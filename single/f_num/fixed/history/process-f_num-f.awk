BEGIN {
    max_nnode = 0;
}
{
    nnode = $1;
    valid_time = $2;
    energy_consumption = $3;

    if (max_nnode < nnode) {
        max_nnode = nnode;
    }

    sum_valid_time[nnode] += valid_time;
    sum_energy_consumption[nnode] += energy_consumption;
    ++count[nnode];
}
END {
    result1 = "f_num-f_vs_vt";
    result2 = "f_num-f_vs_ec";
    for (i = 50; i < max_nnode + 1; i += 20) {
        avg_valid_time[i] = 1.0 * sum_valid_time[i] / count[i];
        avg_energy_consumption[i] = 1.0 * sum_energy_consumption[i] / count[i];
    }
    for (i = 50; i < max_nnode + 1; i += 20) {
        #printf("%3d %5.1f %3d %15f\n", i, avg_valid_time[i], i, avg_energy_consumption[i]);
        printf("%3d %5.1f\n", i, avg_valid_time[i]) > result1;
    }
    for (i = 50; i < max_nnode + 1; i += 20) {
        #printf("%3d %5.1f %3d %15f\n", i, avg_valid_time[i], i, avg_energy_consumption[i]);
        printf("%3d %15f\n", i, avg_energy_consumption[i]) > result2;
    }
}
