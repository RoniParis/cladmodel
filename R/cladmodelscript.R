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

cladmodel <- function(incidence_BOS = 0.88,
                      incidence_RAS = 0.13,
                      baselineFEV1_BOS = 2000,
                      baselineFEV1_RAS = 1520,
                      declineFEV1.year1_BOS = 25.6,
                      declineFEV1.year1_RAS = 21.9,
                      declineFEV1.subsequent_BOS = 25.6,
                      declineFEV1.subsequent_RAS = 21.9,
                      RRdecline_belumosudil_BOS = 0.27,
                      RRdecline_belumosudil_RAS = 0.27,
                      
                      baseline.clad = 1) {
  declineFEV1.year1 <- (declineFEV1.year1_BOS * incidence_BOS) + (declineFEV1.year1_RAS *
                                                                    incidence_RAS)
  declineFEV1.subsequent <- (declineFEV1.subsequent_BOS * incidence_BOS) + (declineFEV1.subsequent_RAS *
                                                                              incidence_RAS)
  
  baselineFEV1 <- (baselineFEV1_BOS * incidence_BOS) + (baselineFEV1_RAS *
                                                          incidence_RAS)
  
  RRdecline_belumosudil <- (RRdecline_belumosudil_BOS * incidence_BOS) + (RRdecline_belumosudil_RAS *
                                                                            incidence_RAS)
  declineFEV1.year1_belumosudil <- declineFEV1.year1 * (1 - RRdecline_belumosudil)
  declineFEV1.subsequent_belumosudil <- declineFEV1.subsequent * (1 - RRdecline_belumosudil)
  
  if (baseline.clad == 1) {
    baseline.decline.percentage <- mean(c(0.65, 0.80))
  }
  if (baseline.clad == 2) {
    baseline.decline.percentage <- mean(c(0.50, 0.65))
  }
  if (baseline.clad == 3) {
    baseline.decline.percentage <- mean(c(0.35, 0.50))
  }
  if (baseline.clad == 4) {
    baseline.decline.percentage <- mean(c(0, 0.35))
  }
  
  
  baselineFEV1.clad0 <- baselineFEV1 / baseline.decline.percentage
  
}



