# India Analytics Hiring Market  2026

## Project Overview

An analysis of the Indian analytics job market using nearly 98,000 job postings to understand what employers are looking for across different analytics-related roles.

The project focuses on identifying the skills, experience requirements, hiring locations, job titles, companies, work modes and salary disclosure patterns found in analytics-related job postings.

After filtering and classifying the dataset, **638 analytics-related jobs** were identified and analyzed across three categories:

- **Core Data Analytics**
- **BI / Reporting / MIS**
- **Adjacent Analytics**

---

## Objective

The objective of this project is to answer:

- What skills are most frequently requested in analytics roles?
- Which combinations of technical skills appear most often?
- What experience levels are most commonly required?
- Where are analytics jobs concentrated geographically?
- Which job titles and companies appear most frequently?
- How do requirements differ across analytics job categories?
- How frequently is salary information disclosed?
- How does the Indian analytics hiring market look from a candidate's perspective?

---

## Dataset

The original dataset contains **97,929 Indian job postings**.

After classification and filtering:

**638 analytics-related jobs** were selected for detailed analysis.

### Job Categories

| Category | Jobs | Market Share |
|---|---:|---:|
| Core Data Analytics | 241 | 37.8% |
| BI / Reporting / MIS | 215 | 33.7% |
| Adjacent Analytics | 182 | 28.5% |
| **Total** | **638** | **100%** |

---

## Methodology

The analysis was performed using MySQL and Excel.

### Data Preparation

- Loaded the Indian job-market dataset into MySQL
- Profiled the dataset and examined its structure
- Identified duplicate job records
- Classified job postings into analytics-related categories
- Standardized and cleaned skill names
- Normalized selected geographic variations
- Split multi-skill fields into individual skill records
- Excluded generic skill terms where appropriate for skill analysis

### Analysis

The SQL analysis covers:

1. Database setup and profiling
2. Market profiling
3. Job classification
4. Skill analysis
5. Experience analysis
6. Geography analysis
7. Job title analysis
8. Company analysis
9. Cross-category comparison
10. Salary analysis

---

## Key Insights

### 1. Core Data Analytics leads the analyzed market

Core Data Analytics is the largest of the three categories, accounting for **241 of 638 jobs (37.8%)**.

This makes traditional data analytics roles the largest segment within the analyzed analytics-related postings.

### 2. SQL, Python and Power BI are the leading Core Analytics skills

Among Core Data Analytics jobs:

- **SQL:** 90 jobs (37.3%)
- **Python:** 85 jobs (35.3%)
- **Power BI:** 74 jobs (30.7%)

The results show strong demand for a combination of querying, programming and business intelligence capabilities.

### 3. SQL + Python is the strongest skill combination

**53 Core Data Analytics jobs** require both SQL and Python, making it the most frequently observed technical skill combination in the analysis.

This indicates that employers often expect analysts to work with both databases and programmatic data analysis.

### 4. Experience requirements differ across analytics segments

The experience distribution varies significantly across the three categories.

- **Core Data Analytics:** highest concentration at 3–5 years — 112 jobs
- **BI / Reporting / MIS:** highest concentration at 1–2 years — 102 jobs
- **Adjacent Analytics:** highest concentration at 3–5 years — 121 jobs

This suggests that different segments of the analytics market target different levels of professional experience.

### 5. Analytics hiring is concentrated in major employment hubs

The five largest identified hiring locations are:

- Bengaluru — 173 jobs
- Hyderabad — 107 jobs
- Mumbai Metro — 103 jobs
- Pune — 63 jobs
- Gurugram — 58 jobs

Together, these locations account for **504 of 638 analyzed jobs (~79%)**.

### 6. Location-based work dominates the analyzed postings

Of the 638 analyzed jobs:

- **On-site / Location Based:** 569 (89.2%)
- **Hybrid:** 50 (7.8%)
- **Remote:** 19 (3.0%)

Remote roles therefore represent a relatively small share of the analyzed postings.

---

## Dashboard

The Excel dashboard summarizes the major findings from the analysis, including:

- Analytics jobs by category
- Market share by category
- Top Core Analytics skills
- Experience requirements
- Work mode distribution
- Salary disclosure
- Top hiring locations
- Key market findings
![India Analytics Hiring Market Dashboard](Dashboard/Screenshot%20\(79\).png)


---

## Tools Used

- **MySQL** — data preparation, classification and analysis
- **Microsoft Excel** — analysis presentation and dashboard development
- **GitHub** — project documentation and version control

---

## Project Structure

```text
india-analytics-hiring-market-2026/
│
├── README.md
│
├── SQL/
│   └── SQL analysis files
│
├── Excel/
│   └── India Hiring Intelligence 2026.xlsx
│
└── Dashboard/
    └── dashboard.png
