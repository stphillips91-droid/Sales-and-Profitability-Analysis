# Sales and Profitability Analysis

> A PostgreSQL project that organizes sales records into related tables and analyzes orders and profit across sales channels.

---

## Overview

This project imports sales records into PostgreSQL, organizes the data into related tables, and uses SQL queries to answer basic business questions about order volume and profitability. It demonstrates data loading, relational table design, and analysis across multiple tables.

---

## Business Problem

Sales records stored in a single flat file can be difficult to manage and analyze consistently. Organizing the records into related tables makes it possible to examine orders, locations, items, and financial results through repeatable queries.

The initial analysis compares order counts and total profit across online and offline sales channels.

---

## Objectives

- Load sales records into a PostgreSQL staging table
- Organize the records into related tables with primary and foreign keys
- Query order counts by sales channel
- Compare total profit across online and offline channels
- Document the data source, table relationships, and analysis

---

## Technologies Used

| Category | Technologies |
|---|---|
| Database | PostgreSQL |
| Language | SQL |
| Development | Visual Studio Code |
| Version control | Git, GitHub |

---

## Data

This project uses a sales records CSV provided for a coursework assignment, and the dataset is not available for public distribution.

The source records include region, country, item type, sales channel, order priority, order date, order ID, ship date, units sold, unit price, unit cost, total revenue, total cost, and total profit.

---

## Repository Structure

```text
sales-profitability-sql/
├── sales_analysis.sql
└── README.md
```

---

## Methodology

1. Create a PostgreSQL database and a staging table for the source records.
2. Load the CSV into the staging table.
3. Separate order, location, item, and financial information into related tables.
4. Define primary and foreign keys for the resulting tables.
5. Query order counts by sales channel.
6. Join the order and financial tables to compare profit across online and offline channels.

---

## Results

The queries produce order counts and total profit for each sales channel. These results provide a starting point for comparing sales activity and profitability.

---

## Key Features

- CSV import into a staging table
- Related tables with primary and foreign keys
- SQL aggregation and joins
- Sales channel comparison

---

## Lessons Learned

This project strengthened my understanding of:

- Loading flat-file data into PostgreSQL
- Structuring related tables
- Applying primary and foreign keys
- Using joins and aggregate queries to answer business questions
- Documenting the steps needed to reproduce an analysis

---

## Future Improvements

- Add verified queries for monthly profit trends
- Use window functions to compare month-over-month results and rank item types within regions
- Review and simplify the staging-to-final-table workflow
- Add data quality checks for duplicate IDs and missing values
- Make the setup and loading instructions easier to reproduce

---

## About Me

I hold an M.S. in Data Analytics with an emphasis in Data Science from Western Governors University. My interests include data analysis, data science, and translating technical findings into practical business recommendations.
