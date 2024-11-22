# linreg: A Simple R Package for Ordinary Least Squares Regression

## Overview

`linreg` is a straightforward R package that allows users to performing Ordinary Least Squares (OLS) regression. It allows you to estimate regression coefficients and their standard errors, and to perform statistical inference on each coefficient via two-sided t-tests.

## Installation

You can install the latest version of linreg from GitHub using the `devtools` package:
```r
# Install devtools if you haven't already
install.packages("devtools")

# Install linreg from GitHub
devtools::install_github("JeffwUmich/linreg")
```

To build the package with the vignette, use:
```R
devtools::install_github("JeffwUmich/linreg", build_vignettes = TRUE)
```

## Usage
```r
# Load the linreg package
library(linreg)

# Perform linear regression
model <- linear_regression(mpg ~ hp + wt, data = mtcars)

# Print the model summary
print(model)
```
### Passing Data Frames and Speciying Formulas
The `linear_regression()` function accepts a formula and a data frame:
- **Formula**: Specifes the model to be fitted. It suues the same syntaxx as R's built-in formula interface. For more details on how to write formulas in R, refer to the [R Documentation](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/formula)
- **Data**: A data frame containing the variables referenced in the formula.

For more detailed infomration and additional exmaples, please view the package vignette:
```r
browseVignettes("linreg")
```
