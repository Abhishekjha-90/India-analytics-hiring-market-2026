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
