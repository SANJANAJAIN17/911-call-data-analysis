USE `Project`;

-- INSIGHT 1: Total 911 Calls, Time Span, and Average Calls Per Day
SELECT
    COUNT(*) AS total_calls,
    MIN(DATE(timeStamp)) AS first_date,
    MAX(DATE(timeStamp)) AS last_date,
    DATEDIFF(MAX(DATE(timeStamp)), MIN(DATE(timeStamp))) + 1 AS num_days,
    ROUND(COUNT(*) / (DATEDIFF(MAX(DATE(timeStamp)), MIN(DATE(timeStamp))) + 1), 2) AS avg_calls_per_day
FROM `911`;

-- INSIGHT 2: Distribution of Calls by Category (EMS, Traffic, Fire)
SELECT
    SUBSTRING_INDEX(title, ':', 1) AS category,
    COUNT(*) AS num_calls,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM `911`), 2) AS pct_of_total
FROM `911`
GROUP BY category
ORDER BY num_calls DESC;

-- INSIGHT 3: Call Volume Trend by Year
SELECT
    YEAR(timeStamp) AS year,
    COUNT(*) AS num_calls
FROM `911`
GROUP BY YEAR(timeStamp)
ORDER BY year;

-- INSIGHT 4: Calls Grouped by Hour of Day (Peak Hours)
SELECT
    HOUR(timeStamp) AS hour_of_day,
    COUNT(*) AS num_calls
FROM `911`
GROUP BY hour_of_day
ORDER BY num_calls DESC;

-- INSIGHT 5: Weekday vs Weekend Call Patterns by Category
SELECT
    CASE WHEN DAYOFWEEK(timeStamp) IN (1,7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    SUBSTRING_INDEX(title, ':', 1) AS category,
    COUNT(*) AS num_calls
FROM `911`
GROUP BY day_type, category
ORDER BY day_type, num_calls DESC;

-- INSIGHT 6: EMS Call Reasons (Detailed Breakdown)
SELECT
    TRIM(SUBSTRING_INDEX(title, ':', -1)) AS ems_reason,
    COUNT(*) AS num_calls
FROM `911`
WHERE SUBSTRING_INDEX(title, ':', 1) = 'EMS'
GROUP BY ems_reason
ORDER BY num_calls DESC;

-- INSIGHT 7: Traffic Incident Reasons (Detailed Breakdown)
SELECT
    TRIM(SUBSTRING_INDEX(title, ':', -1)) AS traffic_reason,
    COUNT(*) AS num_calls
FROM `911`
WHERE SUBSTRING_INDEX(title, ':', 1) = 'Traffic'
GROUP BY traffic_reason
ORDER BY num_calls DESC;

-- INSIGHT 7B: Share of Traffic Calls That Are Vehicle Accidents
SELECT
    SUM(CASE WHEN TRIM(SUBSTRING_INDEX(title, ':', -1)) = 'VEHICLE ACCIDENT' THEN 1 ELSE 0 END) AS vehicle_accidents,
    COUNT(*) AS total_traffic_calls,
    ROUND(
        100 * SUM(CASE WHEN TRIM(SUBSTRING_INDEX(title, ':', -1)) = 'VEHICLE ACCIDENT' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS pct_of_traffic_calls
FROM `911`
WHERE SUBSTRING_INDEX(title, ':', 1) = 'Traffic';

-- INSIGHT 8: Fire Related Call Reasons
SELECT
    TRIM(SUBSTRING_INDEX(title, ':', -1)) AS fire_reason,
    COUNT(*) AS num_calls
FROM `911`
WHERE SUBSTRING_INDEX(title, ':', 1) = 'Fire'
GROUP BY fire_reason
ORDER BY num_calls DESC;

-- INSIGHT 9: Top Townships by Call Volume
SELECT
    twp AS township,
    COUNT(*) AS num_calls,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM `911`), 2) AS pct_of_total
FROM `911`
GROUP BY township
ORDER BY num_calls DESC;

-- INSIGHT 10: Call Volume by Address / Intersection
SELECT
    addr AS address,
    COUNT(*) AS num_calls,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM `911`), 2) AS pct_of_total
FROM `911`
GROUP BY address
ORDER BY num_calls DESC;
