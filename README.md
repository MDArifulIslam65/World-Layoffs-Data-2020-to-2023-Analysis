# World-Layoffs-Data-2020-to-2023-Analysis

## Project Overview

This project explores the economic trends and layoff patterns of the global layoffs from 2020 to 2023. I took raw data through a complete analytics pipeline by executing data cleaning and exploratory data analysis in SQL before designing a dynamic Power BI dashboard. By processing the dataset through this workflow, the project uncovers the structural differences between corporate restructuring and financial distress across industries and different funding levels.


## Software Used

Database Management: MySQL

Data Transformation and Querying: SQL (CTEs, Window Functions, Self-Joins)

Provisional Analysis and Prototyping: Microsoft Excel (Pivot Tables, Conditional Formatting)

Data Modeling & Visualization: Microsoft Power BI, DAX


## Repo Structure

Raw dataset: layoffs.csv

Cleaned Dataset: layoffs_(cleaned dataset).csv

Data Cleaning and EDA Pipeline: World Layoffs Data Cleaning and EDA Project_2.sql

Provisional Analysis: Layoffs Data (cleaned).xlsx

Interactive Dashboard: Layoffs Dashboard.pbix


## Workflow

### 1. Data Cleaning (SQL): The raw data contained duplicates, inconsistent standardisations, and missing values.

Deduplication: Utilized ROW_NUMBER() and PARTITION BY over all columns to isolate and delete duplicate entries.

Standardization: Applied TRIM() and UPDATE statements to fix inconsistent spelling across industry and location columns (e.g., standardizing multiple variations of 'Crypto').

Data Imputation: Engineered JOIN statements to populate missing industry classifications by cross-referencing companies and their geographic locations.

Data Type Conversion: Transformed text-based dates into standard SQL DATE formats for time-series analysis.


### 2. Exploratory Data Analysis (SQL): Using Diagnostic querying to uncover patterns

Layoff Recurrence: Used the LAG() window function to calculate the exact number of days between consecutive layoff rounds for repeat offenders.

Percentile Analysis: Calculated percentiles of company funding to find trends in how the top funded companies differ from the lower funded companies.

Cohort Analysis: Grouped companies by the year of their first layoff to track long-term distress and recidivism over subsequent years.


### 3. Interactive Dashboard Building (PowerBI): Built a two page dynamic dashboard for business insights

Page 1: Global Impact & Industry Reach: Features a chronological timeline, geographic filled maps, and industry breakdowns driven by explicit DAX measures (e.g., Total Layoffs, Impacted Companies) to map the global blast radius.

Page 2: Diagnostic Metrics & Deep Dives: Delivers diagnostic insights via a conditionally formatted matrix highlighting Year-over-Year (YoY) percentage shifts, alongside a scatter plot tracking repeat layoff severity. Offers native drilldowns (Industry ➔ Company, Country ➔ Location) for granular exploration.


## Key Insights

While 2020 represented an immediate macroeconomic shock, 2022 marked a deeper structural collapse across major industries. The United States experienced a 1,014% year-over-year surge in job losses, escalating from 9,470 in 2021 to 105,526 in 2022, while global markets mirrored this during the same period.

Financial backing heavily dictated whether a company could survive a market downturn. Companies that successfully executed partial downsizings held an average funding of $756.6 million, whereas companies that suffered complete operational shutdowns raised an average of only $131.9 million.

Early-stage startups bore the highest risk of total corporate mortality during this period. When analyzing complete business failures, Seed-stage companies experienced the highest volume of closures, followed in descending order by Series B and Series A organizations.

The highest-funded tier of tech companies accounted for the vast majority of absolute job losses, shedding over 95,000 employees. Despite this high volume, their immense capital reserves meant they averaged a relatively low rate of 0.22 employees laid off per million dollars raised.


## Dashboard Screenshots

<img width="1539" height="868" alt="image" src="https://github.com/user-attachments/assets/a7317343-6984-4164-b899-a856f3e3b6d7" />

<img width="1541" height="872" alt="image" src="https://github.com/user-attachments/assets/0e1502f9-3ad1-439a-8388-51b03cf020ae" />



  
