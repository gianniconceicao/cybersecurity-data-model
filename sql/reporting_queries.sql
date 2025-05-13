
-- 1. Monthly critical vulnerability count per device
SELECT
  d.hostname,
  dd.year,
  dd.month,
  COUNT(v.id) AS critical_vulnerability_count
FROM fact_attacks a
LEFT JOIN dim_vulnerability v ON a.vulnerability_id = v.id
LEFT JOIN dim_device d ON a.device_id = d.id
LEFT JOIN dim_date dd ON a.date_id = dd.id
WHERE v.severity = 'Critical'
GROUP BY d.hostname, dd.year, dd.month
ORDER BY d.hostname, dd.year, dd.month;

-- 2. Average mitigation time from detection to closure per incident type
SELECT
  a.attack_type,
  ROUND(AVG(EXTRACT(EPOCH FROM (m.created_at - a.detection_timestamp)) / 3600), 2) AS avg_mitigation_hours
FROM fact_attacks a
LEFT JOIN dim_mitigation m ON a.mitigation_id = m.id
WHERE m.created_at IS NOT NULL
GROUP BY a.attack_type
ORDER BY avg_mitigation_hours DESC;

-- 3. Total number and estimated cost of prevented attacks in a given quarter
SELECT
  dd.year,
  dd.quarter,
  COUNT(a.id) AS total_prevented_attacks,
  SUM(a.estimated_cost) AS estimated_savings
FROM fact_attacks a
LEFT JOIN dim_date dd ON a.date_id = dd.id
WHERE a.prevented = TRUE
GROUP BY dd.year, dd.quarter
ORDER BY dd.year, dd.quarter;

-- 4. Security training completion rate by department in the last 90 days
SELECT
  dep.name AS department,
  ROUND(COUNT(CASE WHEN fst.completed THEN 1 END) * 100.0 / COUNT(*), 0) AS completion_rate_pct
FROM fact_security_training fst
LEFT JOIN dim_user u ON fst.user_id = u.id
LEFT JOIN dim_department dep ON u.department_id = dep.id
LEFT JOIN dim_date dd ON fst.date_id = dd.id
WHERE dd.date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY dep.name
ORDER BY completion_rate_pct DESC;


-- Bonus: High-Risk Device Types
SELECT
  d.device_group,
  COUNT(*) AS total_attacks,
  SUM(CASE WHEN v.severity = 'Critical' THEN 1 ELSE 0 END) AS critical_attacks,
  SUM(CASE WHEN a.prevented = FALSE THEN 1 ELSE 0 END) AS unprevented_attacks
FROM fact_attacks a
JOIN dim_device d ON a.device_id = d.id
JOIN dim_vulnerability v ON a.vulnerability_id = v.id
GROUP BY d.device_group
ORDER BY critical_attacks DESC, unprevented_attacks DESC;
