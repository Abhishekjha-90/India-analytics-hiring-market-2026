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
