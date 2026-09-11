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
