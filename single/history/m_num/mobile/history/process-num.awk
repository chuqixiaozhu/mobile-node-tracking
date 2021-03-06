BEGIN {
    max_nmnode = 0;
}
{
    nmnode = $1;
    valid_time = $2;
    energy_consumption = $3;

    if (max_nmnode < nmnode) {
        max_nmnode = nmnode;
    }

    sum_valid_time[nmnode] += valid_time;
    sum_energy_consumption[nmnode] += energy_consumption;
    ++count[nmnode];
}
END {
    result1 = "m_num_vs_vt"
    result2 = "m_num_vs_ec"
    result3 = "m_num_vs_ee"
    for (i = 0; i < max_nmnode + 1; ++i) {
        avg_valid_time[i] = 1.0 * sum_valid_time[i] / count[i];
        avg_energy_consumption[i] = 1.0 * sum_energy_consumption[i] / count[i];
    }
    for (i = 0; i < max_nmnode + 1; ++i) {
        printf("%3d %5.1f\n", i, avg_valid_time[i]) > result1;
    }
    for (i = 0; i < max_nmnode + 1; ++i) {
        printf("%3d %15f\n", i, avg_energy_consumption[i]) > result2;
    }
    for (i = 0; i < max_nmnode + 1; ++i) {
        printf("%3d %f\n", i, avg_valid_time[i] / avg_energy_consumption[i]) > result3;
    }
    
    result4 = "f_vs_vt"
    result5 = "f_vs_ec"
    result6 = "f_vs_ee"
    f_vt = sum_valid_time[0] / count[0];
    f_ec = sum_energy_consumption[0] / count[0];
    f_ee = f_vt / f_ec;
    for (i = 0; i < max_nmnode + 1; ++i) {
        printf("%3d %5.1f\n", i, f_vt) > result4;
    }
    for (i = 0; i < max_nmnode + 1; ++i) {
        printf("%3d %15f\n", i, f_ec) > result5;
    }
    for (i = 0; i < max_nmnode + 1; ++i) {
        printf("%3d %f\n", i, f_ee) > result6;
    }
}
