# Functions provided by the ThinTin Toy Traders statistician.
# Please use these as they are.

# Identifies results that need to be investigated: any result above
# `single_threshold`, or `run_length` or more consecutive results above
# `run_threshold`. Returns a logical vector the same length as `values`.
flag_points <- function(values, run_threshold = 70, run_length = 3, single_threshold = 140) {
  if (!is.numeric(values)) stop("`values` must be a numeric vector.")
  if (anyNA(values)) stop("`values` contains missing values")
  above <- values > run_threshold
  runs <- rle(above)
  in_long_run <- rep(runs$values & runs$lengths >= run_length, runs$lengths)
  in_long_run | values > single_threshold
}

# Returns the p-value of the Anderson-Darling test (requires the nortest package).
ad_pvalue <- function(values) {
  nortest::ad.test(values)$p.value
}
