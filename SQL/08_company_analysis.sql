  -- =========================================================
-- A17. Top Employers
-- =========================================================

SELECT
    company_name,
    COUNT(DISTINCT job_id) AS jobs

FROM india_analytics_jobs

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
)

GROUP BY company_name

ORDER BY jobs DESC

LIMIT 30;

SELECT
    company_name,
    job_category,
    COUNT(DISTINCT job_id) AS jobs

FROM india_analytics_jobs

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
)

AND company_name IN (
    'Accenture',
    'PRO Hr Complete Solutions',
    'Gratitude India Manpower Consultants Pvt. Ltd.',
    'Wipro',
    'IDESLABS PRIVATE LIMITED',
    'S&P Global Market Intelligence',
    'JPMorgan Chase Bank',
    'Incedo'
)

GROUP BY
    company_name,
    job_category

ORDER BY
    company_name,
    jobs DESC;
