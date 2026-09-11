-- =========================================================
-- DATA ANALYST HIRING INTELLIGENCE REPORT 2026
-- INDIA MARKET ANALYSIS
-- =========================================================

CREATE DATABASE IF NOT EXISTS hiring_intelligence_2026;

USE hiring_intelligence_2026;

CREATE TABLE india_jobs_raw (
    title TEXT,
    job_id TEXT,
    currency TEXT,
    job_uploaded TEXT,
    company_name TEXT,
    tags_and_skills TEXT,
    experience TEXT,
    salary TEXT,
    location TEXT,
    company_id TEXT,
    reviews_count TEXT,
    aggregate_rating TEXT,
    job_description TEXT,
    minimum_salary TEXT,
    maximum_salary TEXT,
    minimum_experience TEXT,
    maximum_experience TEXT
);
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

-- =========================================================
-- A5. Skill Availability
-- =========================================================

SELECT
    COUNT(DISTINCT job_id) AS total_analytics_jobs,

    COUNT(DISTINCT CASE
        WHEN tags_and_skills IS NOT NULL
         AND TRIM(tags_and_skills) <> ''
        THEN job_id
    END) AS jobs_with_skills

FROM india_analytics_jobs

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
);
-- =========================================================
-- A6. Split Skills into Individual Rows
-- =========================================================

DROP TABLE IF EXISTS india_analytics_skills;

CREATE TABLE india_analytics_skills (
    job_id TEXT,
    job_category VARCHAR(50),
    skill TEXT
);

INSERT INTO india_analytics_skills
    (job_id, job_category, skill)

WITH RECURSIVE split_skills AS (

    SELECT
        job_id,
        job_category,

        TRIM(
            SUBSTRING_INDEX(tags_and_skills, ',', 1)
        ) AS skill,

        CASE
            WHEN tags_and_skills LIKE '%,%'
            THEN SUBSTRING(
                tags_and_skills,
                LENGTH(
                    SUBSTRING_INDEX(tags_and_skills, ',', 1)
                ) + 2
            )
            ELSE ''
        END AS remaining_skills

    FROM india_analytics_jobs

    WHERE job_category IN (
        'Core Data Analytics',
        'BI / Reporting / MIS',
        'Adjacent Analytics'
    )
    AND tags_and_skills IS NOT NULL
    AND TRIM(tags_and_skills) <> ''

    UNION ALL

    SELECT
        job_id,
        job_category,

        TRIM(
            SUBSTRING_INDEX(remaining_skills, ',', 1)
        ) AS skill,

        CASE
            WHEN remaining_skills LIKE '%,%'
            THEN SUBSTRING(
                remaining_skills,
                LENGTH(
                    SUBSTRING_INDEX(remaining_skills, ',', 1)
                ) + 2
            )
            ELSE ''
        END AS remaining_skills

    FROM split_skills

    WHERE remaining_skills <> ''
)

SELECT
    job_id,
    job_category,
    skill

FROM split_skills

WHERE skill <> '';

-- =========================================================
-- A7. Raw Skill Demand
-- =========================================================

SELECT
    LOWER(TRIM(skill)) AS skill,
    COUNT(DISTINCT job_id) AS jobs_requiring_skill

FROM india_analytics_skills

WHERE job_category = 'Core Data Analytics'

GROUP BY LOWER(TRIM(skill))

ORDER BY jobs_requiring_skill DESC

LIMIT 20;
-- =========================================================
-- A8. Core Skills Excluding Generic Terms
-- =========================================================

SELECT
    LOWER(TRIM(skill)) AS skill,
    COUNT(DISTINCT job_id) AS jobs_requiring_skill

FROM india_analytics_skills

WHERE job_category = 'Core Data Analytics'

AND LOWER(TRIM(skill)) NOT IN (
    'data',
    'analytical',
    'analysis',
    'analytics',
    'data analyst',
    'data analysis',
    'data analytics'
)

GROUP BY LOWER(TRIM(skill))

ORDER BY jobs_requiring_skill DESC

LIMIT 30;

-- =========================================================
-- A9. Create Clean Skill Table
-- =========================================================

DROP TABLE IF EXISTS india_analytics_skills_clean;

CREATE TABLE india_analytics_skills_clean AS

SELECT DISTINCT
    job_id,
    job_category,

    CASE

        WHEN LOWER(TRIM(skill)) = 'python'
            THEN 'Python'

        WHEN LOWER(TRIM(skill)) = 'sql'
            THEN 'SQL'

        WHEN LOWER(TRIM(skill)) = 'power bi'
            THEN 'Power BI'

        WHEN LOWER(TRIM(skill)) = 'tableau'
            THEN 'Tableau'

        WHEN LOWER(TRIM(skill)) IN (
            'excel',
            'advanced excel'
        )
            THEN 'Excel'

        WHEN LOWER(TRIM(skill)) IN (
            'bi',
            'business intelligence'
        )
            THEN 'Business Intelligence'

        ELSE LOWER(TRIM(skill))

    END AS skill

FROM india_analytics_skills

WHERE TRIM(skill) <> ''

AND LOWER(TRIM(skill)) NOT IN (
    'data',
    'analysis',
    'analytical',
    'analytics',
    'data analysis',
    'data analytics',
    'data analyst'
);

SELECT
    skill,
    COUNT(DISTINCT job_id) AS jobs_requiring_skill

FROM india_analytics_skills_clean

WHERE job_category = 'Core Data Analytics'

AND skill IN (
    'SQL',
    'Python',
    'Power BI',
    'Tableau',
    'Excel',
    'Business Intelligence'
)

GROUP BY skill

ORDER BY jobs_requiring_skill DESC;

-- =========================================================
-- A10. Skill Combinations
-- =========================================================

SELECT
    s1.skill AS skill_1,
    s2.skill AS skill_2,

    COUNT(DISTINCT s1.job_id) AS jobs_requiring_both

FROM india_analytics_skills_clean s1

JOIN india_analytics_skills_clean s2
    ON s1.job_id = s2.job_id
   AND s1.skill < s2.skill

WHERE s1.job_category = 'Core Data Analytics'
  AND s2.job_category = 'Core Data Analytics'

GROUP BY
    s1.skill,
    s2.skill

ORDER BY jobs_requiring_both DESC

LIMIT 30;

-- =========================================================
-- A10-B. Three-Skill Combinations
-- =========================================================

SELECT
    s1.skill AS skill_1,
    s2.skill AS skill_2,
    s3.skill AS skill_3,

    COUNT(DISTINCT s1.job_id) AS jobs_requiring_all_three

FROM india_analytics_skills_clean s1

JOIN india_analytics_skills_clean s2
    ON s1.job_id = s2.job_id
   AND s1.skill < s2.skill

JOIN india_analytics_skills_clean s3
    ON s1.job_id = s3.job_id
   AND s2.skill < s3.skill

WHERE s1.job_category = 'Core Data Analytics'
  AND s2.job_category = 'Core Data Analytics'
  AND s3.job_category = 'Core Data Analytics'

GROUP BY
    s1.skill,
    s2.skill,
    s3.skill

ORDER BY jobs_requiring_all_three DESC

LIMIT 30;

-- =========================================================
-- A11. Experience Distribution
-- =========================================================

SELECT

    CASE
        WHEN minimum_experience = 0
            THEN '0 years'

        WHEN minimum_experience BETWEEN 1 AND 2
            THEN '1-2 years'

        WHEN minimum_experience BETWEEN 3 AND 5
            THEN '3-5 years'

        WHEN minimum_experience BETWEEN 6 AND 10
            THEN '6-10 years'

        WHEN minimum_experience > 10
            THEN '10+ years'

        ELSE 'Not specified'
    END AS experience_group,

    COUNT(DISTINCT job_id) AS job_count

FROM india_analytics_jobs

WHERE job_category = 'Core Data Analytics'

GROUP BY experience_group

ORDER BY
    CASE experience_group
        WHEN '0 years' THEN 1
        WHEN '1-2 years' THEN 2
        WHEN '3-5 years' THEN 3
        WHEN '6-10 years' THEN 4
        WHEN '10+ years' THEN 5
        ELSE 6
    END;
    
    -- =========================================================
-- A12. Skills in Entry-Level Core Analytics Jobs
-- =========================================================

SELECT
    s.skill,
    COUNT(DISTINCT s.job_id) AS jobs_requiring_skill

FROM india_analytics_skills_clean s

JOIN india_analytics_jobs j
    ON s.job_id = j.job_id

WHERE j.job_category = 'Core Data Analytics'
  AND j.minimum_experience BETWEEN 0 AND 2

GROUP BY s.skill

ORDER BY jobs_requiring_skill DESC

LIMIT 20;

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
    
    -- =========================================================
-- A18. Analytics Category Market Share
-- =========================================================

SELECT
    job_category,

    COUNT(DISTINCT job_id) AS jobs,

    ROUND(
        COUNT(DISTINCT job_id) * 100.0 /
        (
            SELECT COUNT(DISTINCT job_id)

            FROM india_analytics_jobs

            WHERE job_category IN (
                'Core Data Analytics',
                'BI / Reporting / MIS',
                'Adjacent Analytics'
            )
        ),
        1
    ) AS market_share

FROM india_analytics_jobs

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
)

GROUP BY job_category

ORDER BY jobs DESC;

-- =========================================================
-- A19. Cross-Category Skill Comparison
-- =========================================================

SELECT
    job_category,
    skill,
    COUNT(DISTINCT job_id) AS jobs

FROM india_analytics_skills_clean

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
)

GROUP BY
    job_category,
    skill

ORDER BY
    job_category,
    jobs DESC;
    
    -- =========================================================
-- A20. Cross-Category Experience Comparison
-- =========================================================

SELECT

    job_category,

    CASE
        WHEN minimum_experience = 0
            THEN '0 years'

        WHEN minimum_experience BETWEEN 1 AND 2
            THEN '1-2 years'

        WHEN minimum_experience BETWEEN 3 AND 5
            THEN '3-5 years'

        WHEN minimum_experience BETWEEN 6 AND 10
            THEN '6-10 years'

        WHEN minimum_experience > 10
            THEN '10+ years'

        ELSE 'Not specified'
    END AS experience_band,

    COUNT(DISTINCT job_id) AS jobs

FROM india_analytics_jobs

WHERE job_category IN (
    'Core Data Analytics',
    'BI / Reporting / MIS',
    'Adjacent Analytics'
)

GROUP BY
    job_category,
    experience_band

ORDER BY
    job_category,

    CASE experience_band
        WHEN '0 years' THEN 1
        WHEN '1-2 years' THEN 2
        WHEN '3-5 years' THEN 3
        WHEN '6-10 years' THEN 4
        WHEN '10+ years' THEN 5
        ELSE 6
    END;
    
    -- =========================================================
-- A21. Salary Analysis
-- =========================================================

SELECT
    job_category,

    COUNT(DISTINCT job_id) AS jobs_with_salary,

    ROUND(AVG(minimum_salary), 0) AS avg_min_salary,

    ROUND(AVG(maximum_salary), 0) AS avg_max_salary,

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

