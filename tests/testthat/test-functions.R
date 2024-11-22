library(linreg)

# Test get_betas
test_that("get_betas works as expected", {
  result <- get_betas(get_betas_input)
  expect_equal(result, get_betas_output)
})

# Test get_residuals
test_that("get_residuals works as expected", {
  result <- get_residuals(get_residuals_input)
  expect_equal(result, get_residuals_output)
})

# Test get_test_statistics
test_that("get_test_statistics works as expected", {
  result <- get_test_statistics(get_test_statistics_input)
  expect_equal(result, get_test_statistics_output)
})

# Test linear_regression
test_that("linear_regression produces expected results", {
  result <- linear_regression(mpg ~ hp + wt + cyl, mtcars)
  expect_equal(result, summary_output)
})




# Test bad input
test_that("linear_regression fails with invalid input", {
  expect_error(
    linear_regression(mpg ~ hp + wtsdf + cyl, mtcars),
    "object 'wtsdf' not found"
  )
})

# Test not full rank matrix
test_that("linear_regression fails with non invertible matrix", {

  not_full_rank_df <- data.frame(
    "a" = c(1,1,1),
    "b" = c(1,1,1)
  )
  expect_error(
    linear_regression(a ~ b, not_full_rank_df),
    "The design matrix is not invertible"
  )
})
