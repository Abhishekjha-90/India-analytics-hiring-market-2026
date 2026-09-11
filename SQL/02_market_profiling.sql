-- =========================================================
-- A1. Overall Job Title Distribution
-- =========================================================
SELECT
    title,
    COUNT(DISTINCT job_id) AS job_count
FROM india_jobs_raw
GROUP BY title
ORDER BY job_count DESC
LIMIT 50;
-- =========================================================
-- A2. Identify Analytics-Related Job Titles
-- =========================================================
SELECT
    title,
    COUNT(DISTINCT job_id) AS job_count
FROM india_jobs_raw
WHERE LOWER(title) LIKE '%analyst%'
   OR LOWER(title) LIKE '%analytics%'
   OR LOWER(title) LIKE '%business intelligence%'
   OR LOWER(title) LIKE '%bi analyst%'
   OR LOWER(title) LIKE '%reporting%'
   OR LOWER(title) LIKE '%mis%'
   OR LOWER(title) LIKE '%insight%'
GROUP BY title
ORDER BY job_count DESC;
