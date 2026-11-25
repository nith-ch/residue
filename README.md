# Residue Explorer
Residue Explorer - ThinTin Toy Traders

# Overview
This project involves developing an R Shiny app for a client, ThinTin Toy Traders. Below is the project background and the client’s requirements.

ThinTin Toy Traders, a manufacturer of teething toys for childrens, needs to monitor its products for the presence of residual lubricants. 
The amount of lubricant residue on each toy component is measured in micrograms per unit. Ideally, there should be no residue. 
However, the company’s specifications allow for a small, permissible amount. Each testing facility analyzes the products manufactured at its respective site and documents the findings in regular reports.

The following files are provided on GitHub:<br>
• thintin_site_A.csv and thintin_site_B.csv: the data files mentioned by the client in their email.<br>
• functions.R: two functions developed by the client’s statistician.

# Features
Data Upload: Upload residue data from CSV or Other files.
Product Selection: Select a product to explore its residue results.
Configurable Thresholds: Modify thresholds to identify potentially unusual observations.
Interactive Visualisation: Analyze residue results using an interactive time series plot.
Flagged Results: Place and review observations that exceed the specified thresholds.
Investigation Decisions: Mark flagged observations as Keep or Remove.
Statistical Analysis: View summary statistics, residue density plots, and the Anderson Darling test.
Export: Download plots as PNG files.

# Libraries
This app requires R and the following R libraries:
• shiny
• readxl
• ggplot2
• plotly
• DT
• dplyr
• nortest