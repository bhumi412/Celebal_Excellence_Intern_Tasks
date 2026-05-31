# Shopping-App-Dataset
Dataset Cleaning  using Pandas

## Data Exploration and Cleaning using Python Pandas

This project demonstrates basic data exploration and cleaning using Python and Pandas on an e-commerce product dataset.

---

## 📌 Objective

The objective of this assignment is to:

* Load a CSV dataset into a Pandas DataFrame
* Explore and understand the dataset
* Handle missing values
* Perform basic data operations
* Remove duplicate records
* Create a derived column
* Save the cleaned dataset as a new CSV file

---

## 🛠️ Technologies Used

* Python
* Pandas
* Jupyter Notebook

---

## 📂 Files Included

* `Datasets-shoping-app.ipynb` → Jupyter Notebook containing complete code
* `cleaned_dataset.csv` → Final cleaned dataset
* `README.md` → Project documentation

---

## 📊 Tasks Performed

### 1. Data Loading

* Loaded the dataset using Pandas
* Handled corrupted rows using `on_bad_lines='skip'`

### 2. Data Exploration

* Viewed dataset shape
* Checked column names and data types
* Displayed first and last rows

### 3. Missing Value Handling

* Identified missing values using `isnull()`
* Removed rows with missing important seller information
* Filled remaining missing values with appropriate defaults

### 4. Data Cleaning

* Cleaned `final_price` column
* Converted string values into numeric format

### 5. Duplicate Removal

* Removed duplicate rows from the dataset

### 6. Basic Operations

* Filtered products based on price
* Selected important columns

### 7. Derived Column Creation

* Created `quantity` column
* Created `total_amount` column using:

```python
total_amount = final_price * quantity
```

### 8. Save Cleaned Dataset

* Exported final cleaned dataset as CSV

---

## ▶️ How to Run the Project

1. Open Jupyter Notebook
2. Run all cells in `Datasets-shoping-app.ipynb`
3. The cleaned dataset will be generated automatically

---

## ✅ Output

* Cleaned dataset file (`cleaned_dataset.csv`)
* Processed and analyzed data in Jupyter Notebook
