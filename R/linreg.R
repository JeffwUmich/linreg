get_betas <- function(calcs){
  # Get variables
  X <- calcs[["X"]]
  y <- calcs[["y"]]
  
  # Calculate the LSE for Beta using backsolver
  XtX<- t(X) %*% X
  R <- chol(XtX)
  R_t_inv <- t(solve(R))
  rhs <- R_t_inv %*% t(X) %*% y
  beta_hat <- backsolve(R, rhs)
  
  # Save calculations
  calcs[c("XX", "R", "R_t_inv", "B_hat")] <- list(XX = XtX, R = R, R_t_inv = R_t_inv, B_hat = beta_hat)
  
  return(calcs)
}


get_residuals <- function(calcs){
  # Get variables
  X <- calcs[["X"]]
  y <- calcs[["y"]]
  B_hat <- calcs[["B_hat"]]
  n <- calcs[["n"]]
  p <- calcs[["p"]]
  
  # Calculate residuals
  e <- y - X %*% B_hat
  num <- t(e) %*% e
  denom <- n - p
  
  # Calculate sigma_2_hat
  sigma_2_hat <- num / denom
  
  # Save calculations
  calcs[c("residuals", "sigma_2_hat")] <- list(residuals = e, sigma_2_hat = sigma_2_hat[[1]])
  
  return(calcs)
}

get_test_statistics <- function(calcs){
  # Get variables
  R <- calcs[["R"]]
  R_t_inv <- calcs[["R_t_inv"]]
  B_hat <- calcs[["B_hat"]]
  sigma_2_hat = calcs[["sigma_2_hat"]]
  n <- calcs[["n"]]
  p <- calcs[["p"]]
  
  # Calculate SE, t-value, and p-values)
  se_B_hat <- sqrt(diag(backsolve(R, sigma_2_hat * R_t_inv)))
  t_values <- as.vector(B_hat) / se_B_hat
  p_values <- 2 * pt(-abs(t_values), n - p)
  
  # Save calculations
  calcs[c("se_B_hat", "t_values", "p_values")] <- list(se_B_hat = se_B_hat, t_values = t_values, p_values = p_values)
  
  return(calcs)
}

get_summary_table <- function(calcs){
  # Get variables
  variables <- calcs[["variables"]]
  B_hat <- as.vector(calcs[["B_hat"]])
  se_B_hat <- calcs[["se_B_hat"]]
  t_values <- calcs[["t_values"]]
  p_values <- calcs[["p_values"]]
  
  # Create summary table
  summary_table <- matrix(c(B_hat, se_B_hat, t_values, p_values), nrow=length(B_hat), ncol=4)
  rownames(summary_table) <- variables
  colnames(summary_table) <- c("Betas",  "SE", "t-values", "Pr(>|t|)")
  
  return(summary_table)
}

linear_regression <- function(formula, data){
  
  # Make sure terms in formula are present in data frame
  terms <- all.vars(formula)
  term_diff <- setdiff(terms, colnames(data))
  
  
  if (length(term_diff) != 0){
    error_message <- paste("The terms: ", paste(term_diff, collapse = ", "), "are not present in the data")
    stop(error_message)
  }
  
  design_matrix <- model.matrix(formula, data = data)
  response <- model.response(model.frame(formula, data))
  
  # Check if design matrix is full rank in the columns
  n <- nrow(design_matrix)
  p <- ncol(design_matrix)
  
  rank <- qr(t(design_matrix) %*% design_matrix)$rank
  
  if (rank != p){
    stop("The design matrix is not invertible")
  }
  
  calcs <- list(variables = colnames(design_matrix), X = design_matrix, y = response, n = n, p = p)
  
  # Calculate estimates
  calcs <- get_betas(calcs)
  # return(calcs[["X"]] %*% calcs[["B_hat"]])
  calcs <- get_residuals(calcs)
  
  
  calcs <- get_test_statistics(calcs)
  
  summary_table <- get_summary_table(calcs)
  
  return(summary_table)
  
  
}