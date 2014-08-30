BEGIN {
    min_t_r_time = max_t_r_time = 10;
}
{
    t_r_time = $1;
    valid_time = $2;
    energy_consumption = $3;

    if (max_t_r_time < t_r_time) {
        max_t_r_time = t_r_time;
    }

    sum_valid_time[t_r_time] += valid_time;
    sum_energy_consumption[t_r_time] += energy_consumption;
    ++count[t_r_time];
}
END {
    result1 = "cluster_vs_vt"
    result2 = "cluster_vs_ec"
    # result3 = "m_num_vs_ee"
    for (i = min_t_r_time; i < max_t_r_time + 1; ++i) {
        avg_valid_time[i] = 1.0 * sum_valid_time[i] / count[i];
        avg_energy_consumption[i] = 1.0 * sum_energy_consumption[i] / count[i];
    }
    for (i = min_t_r_time; i < max_t_r_time + 1; ++i) {
        printf("%3d %5.1f\n", i, avg_valid_time[i]) > result1;
    }
    for (i = min_t_r_time; i < max_t_r_time + 1; ++i) {
        printf("%3d %15f\n", i, avg_energy_consumption[i]) > result2;
    }
}
