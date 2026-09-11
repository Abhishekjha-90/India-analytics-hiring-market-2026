-- =========================================================
-- A13. Location Distribution
-- =========================================================

SELECT
    location,
    COUNT(DISTINCT job_id) AS job_count

FROM india_analytics_jobs

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
)

GROUP BY location

ORDER BY job_count DESC

LIMIT 30;

SELECT

    CASE
        WHEN LOWER(location) LIKE '%remote%'
            THEN 'Remote'

        WHEN LOWER(location) LIKE '%hybrid%'
            THEN 'Hybrid'

        ELSE 'On-site / Location Based'
    END AS work_mode,

    COUNT(DISTINCT job_id) AS job_count

FROM india_analytics_jobs

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
)

GROUP BY work_mode

ORDER BY job_count DESC;

-- =========================================================
-- A14. Normalize Multi-Location Jobs
-- =========================================================

WITH RECURSIVE location_split AS (

    SELECT
        job_id,

        TRIM(
            REPLACE(
                REPLACE(location, 'Hybrid - ', ''),
                'Remote - ',
                ''
            )
        ) AS remaining_location,

        CAST(NULL AS CHAR(255)) AS city

    FROM india_analytics_jobs

    WHERE job_category IN (
        'Core Data Analytics',
        'BI / Reporting / MIS',
        'Adjacent Analytics'
    )

    UNION ALL

    SELECT
        job_id,

        CASE
            WHEN remaining_location LIKE '%,%'
            THEN SUBSTRING(
                remaining_location,
                LOCATE(',', remaining_location) + 1
            )
            ELSE ''
        END,

        TRIM(
            CASE
                WHEN remaining_location LIKE '%,%'
                THEN LEFT(
                    remaining_location,
                    LOCATE(',', remaining_location) - 1
                )
                ELSE remaining_location
            END
        )

    FROM location_split

    WHERE remaining_location <> ''
),

normalized_locations AS (

    SELECT
        job_id,

        CASE

            WHEN LOWER(city) REGEXP '^mumbai'
              OR LOWER(city) LIKE 'mumbai %'
              OR LOWER(city) LIKE 'mumbai(%'
              OR LOWER(city) IN (
                  'navi mumbai',
                  'thane',
                  'goregaon'
              )
            THEN 'Mumbai Metro'

            ELSE TRIM(city)

        END AS city

    FROM location_split

    WHERE city IS NOT NULL
      AND city <> ''
)

SELECT
    city,
    COUNT(DISTINCT job_id) AS job_count

FROM normalized_locations

WHERE city <> 'Remote'

GROUP BY city

ORDER BY job_count DESC

LIMIT 30;

-- =========================================================
-- A15. Delhi/NCR Geography
-- =========================================================

SELECT
    COUNT(DISTINCT job_id) AS delhi_ncr_jobs

FROM india_analytics_jobs

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
)

AND (
       LOWER(location) LIKE '%delhi%'
    OR LOWER(location) LIKE '%noida%'
    OR LOWER(location) LIKE '%gurugram%'
    OR LOWER(location) LIKE '%greater noida%'
    OR LOWER(location) LIKE '%faridabad%'
    OR LOWER(location) LIKE '%ghaziabad%'
    OR LOWER(location) LIKE '%sonipat%'
    OR LOWER(location) LIKE '%palwal%'
);

SELECT
    job_category,
    COUNT(DISTINCT job_id) AS delhi_ncr_jobs

FROM india_analytics_jobs

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
)

AND (
       LOWER(location) LIKE '%delhi%'
    OR LOWER(location) LIKE '%noida%'
    OR LOWER(location) LIKE '%gurugram%'
    OR LOWER(location) LIKE '%greater noida%'
    OR LOWER(location) LIKE '%faridabad%'
    OR LOWER(location) LIKE '%ghaziabad%'
    OR LOWER(location) LIKE '%sonipat%'
    OR LOWER(location) LIKE '%palwal%'
)

GROUP BY job_category

ORDER BY delhi_ncr_jobs DESC;

