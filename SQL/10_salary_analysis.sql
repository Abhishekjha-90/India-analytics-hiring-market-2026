 -- =========================================================
-- A21. Salary Analysis
-- =========================================================

SELECT
    job_category,

    COUNT(DISTINCT job_id) AS jobs_with_salary,

    ROUND(AVG(minimum_salary), 0) AS avg_min_salary,

    ROUND(AVG(maximum_salary), 0) AS avg_max_salary

FROM india_analytics_jobs

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
)

AND minimum_salary > 0
AND maximum_salary > 0

GROUP BY job_category

ORDER BY avg_min_salary DESC;
