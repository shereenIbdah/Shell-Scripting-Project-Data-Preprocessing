# Linux-Shell Scripting Project
Shell Scripting Project – Data Preprocessing
A shell scripting project for data preprocessing, implemented as part of the ENCS3130 Linux Laboratory course at Birzeit University. This script provides an interactive command-line interface to handle encoding and scaling operations on tabular datasets (semicolon-separated).

📁 Features

✅ Dataset Import and Validation
Read dataset files, check formatting, and ensure consistency.

📄 Print Feature Names
View all dataset column headers.

🔠 Label Encoding
Replace categorical values with numeric codes.

🟩 One-Hot Encoding
Transform categorical features into multiple binary columns.

📊 Min-Max Scaling
Normalize numeric features using the standard scaling formula.

💾 Save Processed Dataset
Save the transformed dataset to a file.

🔁 Exit Handling
Prevent accidental exit without saving changes.

🧪 Dataset Format
Data must be clean (no missing values or invalid types).

Columns are separated by a semicolon ;.

The first row must contain column names.

📌 Example Use Cases
Preprocessing before feeding data into machine learning models.

Encoding categorical data in lightweight, CLI-based environments.

Educational tool for understanding shell scripting applied to real-world problems.
