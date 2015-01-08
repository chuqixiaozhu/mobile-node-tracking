BEGIN {
    max_speed = 0;
}
{
    speed = $2;
    valid_time = $3;
    energy_consumption = $4;

    if (max_speed < speed) {
        max_speed = speed;
    }

    sum_valid_time[speed] += valid_time;
    sum_energy_consumption[speed] += energy_consumption;
    ++count[speed];
}
END {
    for (i = 1; i < max_speed + 1; ++i) {
        avg_valid_time[i] = 1.0 * sum_valid_time[i] / count[i];
        avg_energy_consumption[i] = 1.0 * sum_energy_consumption[i] / count[i];
    }
    for (i = 1; i < max_speed + 1; ++i) {
        printf("%3d %11f %3d %15f\n", i, avg_valid_time[i], i, avg_energy_consumption[i]);
    }
}
