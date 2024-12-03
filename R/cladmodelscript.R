#' Calculate the sum and difference of two numbers
#'
#' This function returns the sum and the difference of two numbers.
#'
#' @param x A numeric value. The first number.
#' @param y A numeric value. The second number.
#'
#' @return A list containing the sum and difference of `x` and `y`.
#'   The sum is in the `sum` element, and the difference in the `difference` element.
#'
#' @examples
#' result$sum           # Returns 8
#' result$difference    # Returns 2
#'
#' @export

cladmodel <- function(p_incidence_BOS = 0.875,
                      p_incidence_RAS = 0.125,
                      n_baselineFEV1_BOS = 2000,
                      n_baselineFEV1_RAS = 1520,
                      n_declineFEV1.year1_BOS = 25.6,
                      n_declineFEV1.year1_RAS = 21.9,
                      n_declineFEV1.subsequent_BOS = 25.6,
                      n_declineFEV1.subsequent_RAS = 21.9,
                      rr_decline_belumosudil_BOS = 0.27,
                      rr_decline_belumosudil_RAS = 0.27,
                      
                      n_baseline.clad = 1) {
  
  n_declineFEV1.year1 <- (n_declineFEV1.year1_BOS * p_incidence_BOS) + (n_declineFEV1.year1_RAS *
                                                                    p_incidence_RAS)
  n_declineFEV1.subsequent <- (n_declineFEV1.subsequent_BOS * p_incidence_BOS) + (n_declineFEV1.subsequent_RAS *
                                                                              p_incidence_RAS)
  
  n_baselineFEV1 <- (n_baselineFEV1_BOS * p_incidence_BOS) + (n_baselineFEV1_RAS *
                                                          p_incidence_RAS)
  
  rr_decline_belumosudil <- (rr_decline_belumosudil_BOS * p_incidence_BOS) + (rr_decline_belumosudil_RAS *
                                                                            p_incidence_RAS)
  n_declineFEV1.year1_belumosudil <- n_declineFEV1.year1 * (1 - rr_decline_belumosudil)
  n_declineFEV1.subsequent_belumosudil <- n_declineFEV1.subsequent * (1 - rr_decline_belumosudil)
  
  if (n_baseline.clad == 1) {
    n_baseline.decline.percentage <- mean(c(0.65, 0.80))
  }
  if (n_baseline.clad == 2) {
    n_baseline.decline.percentage <- mean(c(0.50, 0.65))
  }
  if (n_baseline.clad == 3) {
    n_baseline.decline.percentage <- mean(c(0.35, 0.50))
  }
  if (n_baseline.clad == 4) {
    n_baseline.decline.percentage <- mean(c(0, 0.35))
  }
  
  
  n_baselineFEV1.clad0 <- n_baselineFEV1 / n_baseline.decline.percentage 
  
}





