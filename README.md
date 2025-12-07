
# Analysis of UK Migration Data Using SQL and Power BI

This repository contains the complete analytical workflow for examining UK migration datasets using **SQL-based preprocessing** and **Power BI–based visualisation**.
The project was completed as part of the course **Advanced SQL and Cloud Databases (LB 2224)**,
BSc in Applied Data Science & Communication — Year 02, Semester 02 at **General Sir John Kotelawala Defence University (KDU)**.

---

## 1. Project Overview

Migration plays a vital role in shaping labour markets, economic growth, and public policy decisions in the United Kingdom.
This project transforms raw migration datasets published by the **UK Home Office** into structured, analysable formats using SQL Server and Power BI.

The project workflow includes:

* Data loading, cleaning, and preprocessing using **SQL Server**
* Creation of clean **fact and dimension tables**
* Data modelling, relationships, and transformation in **Power BI**
* Development of **DAX measures** for analytical computations
* Building an interactive **Power BI dashboard** for trend analysis and insights

The final deliverable is a fully interactive Power BI report, supported by a robust SQL-driven data preparation pipeline.

---

## 2. Methods and Tools Used

### SQL Server

* Data import, cleansing, and transformation
* Standardisation of inconsistent fields (dates, categories, text formatting)
* Removal of missing, null, and invalid entries
* Creation of clean fact and dimension tables with proper data types

### Power BI

* Data modelling and relationship management
* Development of calculated columns and **DAX measures**
* KPI indicators and time-series visualisations
* Interactive dashboard design with drill-through pages and slicers

---

## 3. Repository Structure

```
uk-migration-analysis-sql-powerbi/
│
├── data/            # Raw CSV datasets from the UK Home Office
├── sql/             # SQL scripts for data cleaning & processing
├── pbix/            # Final Power BI dashboard (.pbix file)
├── documentation/   # Assignment report (PDF/DOCX) & supplementary files
└── README.md        # Project documentation
```
---

## 4. Contents of the Repository

* **Task 01.pbix** — Final Power BI dashboard report
* **Task 1.sql** — SQL cleaning and transformation scripts
* **Raw CSV datasets** — Imported from official UK Home Office sources
* **Assignment report** (PDF/DOCX)
---

## 5. Key Insights from the Analysis

The analysis reveals significant migration trends:

* Total applications (2010–2023): ~6 million
* Study visas account for ~66.7% of all applications
* Major contributing countries: China, India, Nigeria
* Key work sectors: Healthcare, IT, Professional Services
* Visa and extension patterns demonstrate policy impact
* COVID-19 and post-pandemic recovery trends are evident
* Seasonal and quarterly fluctuations highlight institutional demand

These insights support informed policy evaluation and data-driven decision-making.

---

## 6. How to Run

1. Load SQL scripts in **SQL Server** to create and clean tables.
2. Open `Task 01.pbix` in **Power BI Desktop**.
3. Connect PBIX to SQL Server database if using live connection, or continue with imported tables.
4. Interact with the dashboard using slicers, drill-through pages, and bookmarks.

---

## 7. Academic Information

* **Course:** Advanced SQL and Cloud Databases (LB 2224)
* **Programme:** BSc in Applied Data Science & Communication
* **University:** General Sir John Kotelawala Defence University (KDU)

## 8. Contact

For inquiries or clarifications regarding this project:

* **Email:** [navodyasathsarani2003@gmail.com](mailto:navodyasathsarani2003@gmail.com)
* **GitHub:** [github.com/ChathumiNavodya](https://github.com/ChathumiNavodya)


