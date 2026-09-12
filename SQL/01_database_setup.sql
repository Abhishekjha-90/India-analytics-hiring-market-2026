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

---
### Description

-- This script initializes the MySQL database for the project and creates the `india_jobs_raw` table to store the original Indian job-market dataset.

-- The table contains job-level information including job titles, companies, skills, experience requirements, locations, salary fields, and other posting-level attributes.

-- This raw table serves as the starting point for the subsequent data cleaning, job classification, skill analysis, experience analysis, geographic analysis, company analysis, and salary analysis performed throughout the project.
