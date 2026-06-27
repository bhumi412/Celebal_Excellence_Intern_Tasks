# Week 6 - Spark Architecture and Data Processing

## Overview

This project demonstrates the use of Apache Spark (PySpark) for efficient data processing using DataFrames. The project covers Spark architecture concepts along with practical data processing tasks such as reading data, schema handling, filtering, transformations, and writing processed data into different file formats.

---

## Objectives

- Understand Spark Architecture (Driver, Cluster Manager, Executors)
- Learn Lazy Evaluation and DAG execution
- Read CSV files with schema inference
- Explore and clean datasets
- Handle missing values and duplicate records
- Apply DataFrame transformations and actions
- Filter and select required data
- Rename columns and cast data types
- Create new columns using transformations
- Save processed data as CSV and Parquet
- Compare CSV and Parquet formats
- Understand Predicate Pushdown and Spark performance optimization

---

## Dataset

**Dataset:** Employee Dataset

The dataset contains employee-related information including:

- Education
- JoiningYear
- City
- PaymentTier
- Age
- Gender
- EverBenched
- ExperienceInCurrentDomain
- LeaveOrNot

Total Records: **4653**

---

## Technologies Used

- Python
- Apache Spark (PySpark)
- Google Colab / Jupyter Notebook

---

## Project Workflow

1. Create Spark Session
2. Load CSV dataset
3. Explore the dataset
4. Check schema
5. Check missing values
6. Remove duplicate records
7. Filter employee records
8. Select required columns
9. Rename columns
10. Cast data types
11. Add a new column
12. Apply transformations and actions
13. Save processed data as CSV
14. Save processed data as Parquet
15. Study Spark Architecture and performance concepts

---

## Spark Concepts Covered

- Spark Driver
- Cluster Manager
- Executors
- Lazy Evaluation
- Directed Acyclic Graph (DAG)
- Transformations
- Actions
- Client Mode vs Cluster Mode
- CSV vs Parquet
- Predicate Pushdown
- Shuffle Operations

---

## Output

The processed dataset is generated in:

- `output_csv/`
- `output_parquet/`

---

## Key Learnings

- Learned how Spark processes large datasets using distributed computing.
- Understood the importance of Lazy Evaluation and DAG optimization.
- Performed data cleaning and transformation using PySpark DataFrames.
- Compared CSV and Parquet storage formats.
- Learned best practices for efficient Spark data processing.
---

## Conclusion

This project provided practical experience with Apache Spark and DataFrame operations. It helped in understanding Spark architecture, efficient data processing techniques, and performance optimization concepts that are commonly used in modern data engineering workflows.
