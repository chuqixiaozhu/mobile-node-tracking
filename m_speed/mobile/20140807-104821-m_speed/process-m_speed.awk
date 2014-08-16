BEGIN {
    max_m_speed = 0;
}
{
    m_speed = $1;
    m_speed = int(m_speed * 10);
    valid_time = $2;
    energy_consumption = $3;

    if (max_m_speed < m_speed) {
        max_m_speed = m_speed;
    }

    sum_valid_time[m_speed] += valid_time;
    sum_energy_consumption[m_speed] += energy_consumption;
    ++count[m_speed];
}
END {
    result1 = "m_speed_vs_vt"
    result2 = "m_speed_vs_ec"
    for (i = 0; i < max_m_speed + 1; i += 2) {
        avg_valid_time[i] = 1.0 * sum_valid_time[i] / count[i];
        avg_energy_consumption[i] = 1.0 * sum_energy_consumption[i] / count[i];
    }
    for (i = 0; i < max_m_speed + 1; i += 2) {
        printf("%4.1f %5.1f\n", i / 10.0, avg_valid_time[i]) > result1;
    }
    for (i = 0; i < max_m_speed + 1; i += 2) {
        printf("%4.1f %15f\n", i / 10.0, avg_energy_consumption[i]) > result2;
    }
}
