-- =========================================================
-- A16. Job Title Distribution by Category
-- =========================================================

SELECT
    job_category,
    title,
    COUNT(DISTINCT job_id) AS jobs

FROM india_analytics_jobs

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
)

GROUP BY
    job_category,
    title

ORDER BY
    job_category,
    jobs DESC;
