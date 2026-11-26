# Residue Explorer
Residue Explorer - ThinTin Toy Traders

# Overview
This project involves developing an R Shiny app for a client, ThinTin Toy Traders. Below is the project background and the client’s requirements.<br>

ThinTin Toy Traders, a manufacturer of teething toys for childrens, needs to monitor its products for the presence of residual lubricants.<br>
The amount of lubricant residue on each toy component is measured in micrograms per unit. Ideally, there should be no residue.<br>
However, the company’s specifications allow for a small, permissible amount. Each testing facility analyzes the products manufactured at its respective site and documents the findings in regular reports.

The following files are provided on GitHub:<br>
• thintin_site_A.csv and thintin_site_B.csv: the data files mentioned by the client in their email.<br>
• functions.R: two functions developed by the client’s statistician.

# Features
• Data Upload: Upload residue data from CSV or Other files.<br>
• Product Selection: Select a product to explore its residue results.<br>
• Configurable Thresholds: Modify thresholds to identify potentially unusual observations.<br>
• Interactive Visualisation: Analyze residue results using an interactive time series plot.<br>
• Flagged Results: Place and review observations that exceed the specified thresholds.<br>
• Investigation Decisions: Mark flagged observations as Keep or Remove.<br>
• Statistical Analysis: View summary statistics, residue density plots, and the Anderson-Darling test.<br>
• Export: Download plots as PNG files.

# Project Structure
<<<<<<< HEAD
residue/
├─ app.R<br>
├─ functions.R<br>
├─ README.md<br>
├─ residue.Rproj<br>
├─ .gitignore<br>
├─ .gitattributes<br>
└─ Data/<br>
  - thintin_site_A.csv<br>
  - thintin_site_B.csv
=======
residue/<br>
├── app.R<br>
├── functions.R<br>
├── README.md<br>
├── residue.Rproj<br>
├── .gitignore<br>
├── .gitattributes<br>
└── Data/<br>
    └── thintin_site_A.csv<br>
    └── thintin_site_B.csv
>>>>>>> 3592696d2857a30fc335338fe2a81c55463028b2

# Libraries
This app requires R and the following R libraries:<br>
• shiny<br>
• readxl<br>
• ggplot2<br>
• plotly<br>
• DT<br>
• dplyr<br>
• nortest<br>

# Statistical Analysis
This application provides descriptive statistics and visualization tools to support the monitoring and examination of residuals, including:
• Summary statistics
• Density plots of the residuals
• The p-value from the Anderson–Darling test
These tools enable users to explore the distribution and characteristics of the measured residuals.
