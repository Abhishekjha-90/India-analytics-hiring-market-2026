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
