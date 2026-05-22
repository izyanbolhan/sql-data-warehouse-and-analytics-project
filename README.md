# Data Warehouse & Analytics Project

This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Desgined as a portfolio project highlights industry best practices in data engineering and analytics.

---

## Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective : Develop a modern data warehouse using SQL server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources** : Import data from two source systems (ERP and CRM) provided as CSV file
- **Data Quality** : Cleanse and resolve data quality issues prior to analysis
- **Integration** : Combine both sources into a single, user-friendly data model designed for analytical queries
- **Scope** : Focus on the latest dataset only; historization of data is not required
- **Documentation** : Provide clear documentation of the data model to support both business stakeholders and analytics team

---

### BI : Analytics & Reporting (Data Analytics)

 #### Objective : Develop SQL-based analytics to deliver detailed insights into :
 - **Customer Behaviour**
 - **Product Performance**
 - **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.


## Data Architecture
The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:

<img width="1521" height="744" alt="High_Level_Architecture" src="https://github.com/user-attachments/assets/2a7162a0-6027-471f-8434-9a8fa99b444e" />

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

## Data Flow Diagram
The data flow diagram shows the relationship from CRM and ERP sources for each **Bronze**, **Silver**, and **Gold** layers:

<img width="1341" height="514" alt="Data_Flow_Diagram" src="https://github.com/user-attachments/assets/a83920b0-988b-49e7-95be-1d7adecf359e" />

1. **Bronze Layer**: to upload source data into the 'bronze' schema from external CSV files.
2. **Silver Layer**: performs the ETL (Extract, Transform, Load) process to populate the 'silver' schema tables from the 'bronze' schema.
3. **Gold Layer**: each view performs transformations and combines data from the Silver layer to produce a clean, enriched, and business-ready dataset

## Integration Model
The integration model below shows how tables are related based on the primary key to prepare the dimension and fact tables for **Gold** layers. It combines both sources into a single, user-friendly data model designed for analytical queries.

<img width="1091" height="569" alt="Integration Model" src="https://github.com/user-attachments/assets/2f4bf7a3-0588-431b-8c9d-f9e1a1c455c9" />

## Sales_Data Mart
The sales data mart shows the fact and dimension tables in view format. This is the final output tables before proceed on SQL Explatory Data Analysis (EDA).
<img width="1161" height="506" alt="Sales_Data_Mart" src="https://github.com/user-attachments/assets/d73f0ac4-6feb-454c-a888-9f977846e9ed" />

## Summary on Building the Data Warehouse (Data Engineering)
The Data Warehouse are built based on
  - imported data from two source systems (ERP and CRM) provided in csv file.
  - data quality issues was checked and resolve prior to analysis
  - both sources combined into a single, user-friendly data model designed for analytical queries
  - documention of the data model provided to support both business stakeholders and analytics team


