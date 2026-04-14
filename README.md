# Data Warehouse and Analytics Project

This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

---

## Data Architecture

The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers:
<img width="1071" height="579" alt="Screenshot 2026-04-10 at 9 33 24 PM" src="https://github.com/user-attachments/assets/4be3d314-60e5-4ab5-9429-b885f57bfae0" />

- Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
- Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
- Gold Layer: Houses business-ready data modeled into a star schema required for reporting and analytics.

---

## Project Overview

This project involves:

1. Data Architecture: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
2. ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.
3. Data Modeling: Developing fact and dimension tables optimized for analytical queries.
4. Analytics & Reporting: Creating SQL-based reports and dashboards for actionable insights.

🎯 This repository is an excellent resource to showcase expertise in:

- SQL Development
- Data Architect
- Data Engineering
- ETL Pipeline Developer
- Data Modeling
- Data Analytics

## Important Links & Tools:

- Datasets: Access to the project dataset (csv files).
- MySQL WorkBench: GUI for managing and interacting with databases.
- Git Repository: Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- DrawIO: Design data architecture, models, flows, and diagrams.
- Notion: Get the Project Template from Notion
- [Notion Project Steps](https://www.notion.so/SQL-Data-Warehouse-Project-fcd6b4eec1398281912301fc1281ec54?source=copy_link): Access to All Project Phases and Tasks.
## Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective

Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications

- Data Sources: Import data from two source systems (ERP and CRM) provided as CSV files.
- Data Quality: Cleanse and resolve data quality issues prior to analysis.
- Integration: Combine both sources into a single, user-friendly data model designed for analytical queries.
- Scope: Focus on the latest dataset only; historization of data is not required.
- Documentation: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

### BI: Analytics & Reporting (Data Analysis)

#### Objective

Develop SQL-based analytics to deliver detailed insights into:

- Customer Behavior
- Product Performance
- Sales Trends

These insights empower stakeholders with key business metrics, enabling strategic decision-making.
