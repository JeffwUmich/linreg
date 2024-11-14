# Load linreg library
library(linreg)

# run the OLS model: mpg = hp + wt from the mtcars dataset
summary_results <- linear_regression(mpg ~ hp + wt, data = mtcars)
print(summary_results)
