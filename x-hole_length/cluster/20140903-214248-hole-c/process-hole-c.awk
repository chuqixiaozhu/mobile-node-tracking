BEGIN {
    min_hole_length = max_hole_length = 10;
}
{
    hole_length = $1;
    valid_time = $2;
    energy_consumption = $3;

    if (max_hole_length < hole_length) {
        max_hole_length = hole_length;
    }

    sum_valid_time[hole_length] += valid_time;
    sum_energy_consumption[hole_length] += energy_consumption;
    ++count[hole_length];
}
END {
    result1 = "hole-c_vs_vt"
    result2 = "hole-c_vs_ec"
    # result3 = "m_num_vs_ee"
    for (i = min_hole_length; i < max_hole_length + 1; i += 10) {
        avg_valid_time[i] = 1.0 * sum_valid_time[i] / count[i];
        avg_energy_consumption[i] = 1.0 * sum_energy_consumption[i] / count[i];
    }
    for (i = min_hole_length; i < max_hole_length + 1; i += 10) {
        printf("%3d %5.1f\n", i, avg_valid_time[i]) > result1;
    }
    for (i = min_hole_length; i < max_hole_length + 1; i += 10) {
        printf("%3d %15f\n", i, avg_energy_consumption[i]) > result2;
    }
}
