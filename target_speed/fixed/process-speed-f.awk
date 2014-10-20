BEGIN {
    max_speed = 0;
}
{
    speed = $1;
    valid_time = $2;
    energy_consumption = $3;

    if (max_speed < speed) {
        max_speed = speed;
    }

    sum_valid_time[speed] += valid_time;
    sum_energy_consumption[speed] += energy_consumption;
    ++count[speed];
}
END {
    result1 = "speed-f_vs_vt"
    result2 = "speed-f_vs_ec"
    for (i = 1; i < max_speed + 1; ++i) {
        avg_valid_time[i] = 1.0 * sum_valid_time[i] / count[i];
        avg_energy_consumption[i] = 1.0 * sum_energy_consumption[i] / count[i];
    }
    for (i = 1; i < max_speed + 1; ++i) {
        printf("%3d %5.1f\n", i, avg_valid_time[i]) > result1;
    }
    for (i = 1; i < max_speed + 1; ++i) {
        printf("%3d %15f\n", i, avg_energy_consumption[i]) > result2;
    }
}
