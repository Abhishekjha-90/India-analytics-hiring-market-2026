-- =========================================================
-- A3. Classify Jobs into Analytics Categories
-- =========================================================

SELECT
    CASE

        -- CORE DATA ANALYTICS
        WHEN (
               LOWER(title) LIKE '%data analyst%'
            OR LOWER(title) LIKE '%business data analyst%'
        )
        AND LOWER(title) NOT LIKE '%clinical%'
        AND LOWER(title) NOT LIKE '%medical%'
        AND LOWER(title) NOT LIKE '%master data%'
        AND LOWER(title) NOT LIKE '%reference data%'
        AND LOWER(title) NOT LIKE '%gis%'
        AND LOWER(title) NOT LIKE '%technical data analyst%'
        AND LOWER(title) NOT LIKE '%engineering data analyst%'
        AND LOWER(title) NOT LIKE '%data analyst trainer%'
        AND LOWER(title) NOT LIKE '%data science%'
        AND LOWER(title) NOT LIKE '%qa engineer%'
        AND LOWER(title) NOT LIKE '%bi & ml%'
        AND LOWER(title) NOT LIKE '%administrator%'
        THEN 'Core Data Analytics'

        -- BI / REPORTING / MIS
        WHEN
               LOWER(title) LIKE '%business intelligence%'
            OR LOWER(title) LIKE '%bi analyst%'
            OR LOWER(title) LIKE '%reporting analyst%'
            OR LOWER(title) LIKE '%reporting & analytics%'
            OR LOWER(title) LIKE '%mis analyst%'
            OR LOWER(title) LIKE '%mis executive%'
        THEN 'BI / Reporting / MIS'

        -- ADJACENT ANALYTICS
        WHEN
               LOWER(title) LIKE '%product analyst%'
            OR LOWER(title) LIKE '%marketing analyst%'
            OR LOWER(title) LIKE '%digital analyst%'
            OR LOWER(title) LIKE '%operations analyst%'
            OR LOWER(title) LIKE '%supply chain analyst%'
            OR LOWER(title) LIKE '%clinical data analyst%'
            OR LOWER(title) LIKE '%medical data analyst%'
            OR LOWER(title) LIKE '%financial data analyst%'
            OR LOWER(title) LIKE '%risk data analyst%'
            OR LOWER(title) LIKE '%rwe data analyst%'
        THEN 'Adjacent Analytics'

        ELSE 'Other'
    END AS job_category,

    COUNT(DISTINCT job_id) AS job_count

FROM india_jobs_raw

GROUP BY job_category
ORDER BY job_count DESC;

-- =========================================================
-- A4. Create Permanent Classified Analytics Table
-- =========================================================

DROP TABLE IF EXISTS india_analytics_jobs;

CREATE TABLE india_analytics_jobs
LIKE india_jobs_raw;

ALTER TABLE india_analytics_jobs
ADD COLUMN job_category VARCHAR(50);

INSERT INTO india_analytics_jobs

SELECT
    *,
    CASE

        WHEN (
               LOWER(title) LIKE '%data analyst%'
            OR LOWER(title) LIKE '%business data analyst%'
        )
        AND LOWER(title) NOT LIKE '%clinical%'
        AND LOWER(title) NOT LIKE '%medical%'
        AND LOWER(title) NOT LIKE '%master data%'
        AND LOWER(title) NOT LIKE '%reference data%'
        AND LOWER(title) NOT LIKE '%gis%'
        AND LOWER(title) NOT LIKE '%technical data analyst%'
        AND LOWER(title) NOT LIKE '%engineering data analyst%'
        AND LOWER(title) NOT LIKE '%data analyst trainer%'
        AND LOWER(title) NOT LIKE '%data science%'
        AND LOWER(title) NOT LIKE '%qa engineer%'
        AND LOWER(title) NOT LIKE '%bi & ml%'
        AND LOWER(title) NOT LIKE '%administrator%'
        THEN 'Core Data Analytics'

        WHEN
               LOWER(title) LIKE '%business intelligence%'
            OR LOWER(title) LIKE '%bi analyst%'
            OR LOWER(title) LIKE '%reporting analyst%'
            OR LOWER(title) LIKE '%reporting & analytics%'
            OR LOWER(title) LIKE '%mis analyst%'
            OR LOWER(title) LIKE '%mis executive%'
        THEN 'BI / Reporting / MIS'

        WHEN
               LOWER(title) LIKE '%product analyst%'
            OR LOWER(title) LIKE '%marketing analyst%'
            OR LOWER(title) LIKE '%digital analyst%'
            OR LOWER(title) LIKE '%operations analyst%'
            OR LOWER(title) LIKE '%supply chain analyst%'
            OR LOWER(title) LIKE '%clinical data analyst%'
            OR LOWER(title) LIKE '%medical data analyst%'
            OR LOWER(title) LIKE '%financial data analyst%'
            OR LOWER(title) LIKE '%risk data analyst%'
            OR LOWER(title) LIKE '%rwe data analyst%'
        THEN 'Adjacent Analytics'

        ELSE 'Other'

    END AS job_category

FROM india_jobs_raw;

SELECT
    job_category,
    COUNT(DISTINCT job_id) AS job_count
FROM india_analytics_jobs
GROUP BY job_category
ORDER BY job_count DESC;

