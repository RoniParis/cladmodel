library(dplyr)
library(readxl)
library(heemod)


# -----------------------------------------------------
# General Settings
# -----------------------------------------------------
time_horizon <- 50            # Time horizon for the analysis (in years)
dr_cost <- 0.035              # Discount rate for costs
dr_outcomes <- 0.035          # Discount rate for health outcomes
wtp_threshold <- 30000        # Willingness-to-pay threshold (in monetary units)

# -----------------------------------------------------
# Patient Population Characteristics
# -----------------------------------------------------
mean_age <- 56                # Average age of the patient population
female_percentage <- 0.43     # Proportion of female patients
mean_weight <- 82             # Average weight of the patient population (in kg)

# -----------------------------------------------------
# Disease Incidence Probabilities
# -----------------------------------------------------
p_incidence_BOS <- 0.875      # Probability of BOS phenotypes
p_incidence_RAS <- 0.125      # Probability of RAS phenotypes

# -----------------------------------------------------
# Baseline Characteristics (FEV1)
# -----------------------------------------------------
n_baseline.clad <- 1          # Baseline Clad stage is set to 1
n_baselineFEV1_BOS <- 2000    # Baseline FEV1 value for BOS patients (in mL)
n_baselineFEV1_RAS <- 1520    # Baseline FEV1 value for RAS patients (in mL)

# -----------------------------------------------------
# Annual FEV1 Decline
# -----------------------------------------------------
# Year 1 FEV1 decline rates
n_declineFEV1.year1_BOS <- 25.556  # Decline rate for BOS patients (mL/year)
n_declineFEV1.year1_RAS <- 21.944  # Decline rate for RAS patients (mL/year)

# Subsequent years FEV1 decline rates
n_declineFEV1.subsequent_BOS <- 25.556  # Subsequent decline rate for BOS patients (mL/year)
n_declineFEV1.subsequent_RAS <- 21.944  # Subsequent decline rate for RAS patients (mL/year)

# Relative risk reduction of FEV1 decline with Belumosudil
rr_decline_belumosudil_BOS <- 0.27  # BOS patients
rr_decline_belumosudil_RAS <- 0.27  # RAS patients

# -----------------------------------------------------
# Survival Analysis Parameters
# -----------------------------------------------------
survival_function <- "Log-normal"  # Type of survival distribution used
hr_belumosudil <- 0.73             # Hazard ratio for Belumosudil
hr_clad1 <- 0.8                    # Hazard ratio for Clad1
hr_clad2 <- 1                      # Hazard ratio for Clad2
hr_clad3 <- 1.5                    # Hazard ratio for Clad3
hr_clad4 <- 3                      # Hazard ratio for Clad4

# -----------------------------------------------------
# Lung Transplantation (LTx) Probabilities
# -----------------------------------------------------
# Belumosudil probabilities for different Clad levels
p_LTx_clad1_belumosudil <- 0
p_LTx_clad2_belumosudil <- 0.0000387
p_LTx_clad3_belumosudil <- 0.0000387
p_LTx_clad4_belumosudil <- 0.0000387

# Best Supportive Care (BSC) probabilities for different Clad levels
p_LTx_clad1_BSC <- 0
p_LTx_clad2_BSC <- 0.0000387
p_LTx_clad3_BSC <- 0.0000387
p_LTx_clad4_BSC <- 0.0000387

# -----------------------------------------------------
# Stop Rule Probabilities (for different Clad levels)
# -----------------------------------------------------
p_stoprule_clad1 <- 0
p_stoprule_clad2 <- 0
p_stoprule_clad3 <- 0
p_stoprule_clad4 <- 1          # Only applied for Clad4 level

# -----------------------------------------------------
# Discontinuation Rate for Belumosudil
# -----------------------------------------------------
p_disc_belumosudil <- 0.0119   # Probability of discontinuing Belumosudil

# -----------------------------------------------------
# Adverse Event (AE) Probabilities
# -----------------------------------------------------

# Percentage of AEs managed in outpatient setting
p_AE_managed.outpatient <- 1  

# Probabilities of AEs for Belumosudil
p_AE_pneumonia_belumosudil <- 0.003576921
p_AE_hypertension_belumosudil <- 0.003576921
p_AE_anaemia_belumosudil <- 0.002039584
p_AE_thrombocytopenia_belumosudil <- 0.001540479
p_AE_hyperglycaemia_belumosudil <- 0.002579999
p_AE_GGT_increased_belumosudil <- 0.002579999
p_AE_diarrhoea_belumosudil <- 0.000
p_AE_AE8_belumosudil <- 0.000
p_AE_AE9_belumosudil <- 0.000
p_AE_AE10_belumosudil <- 0.000
p_AE_AE11_belumosudil <- 0.000

# Probabilities of AEs for Best Supportive Care (BSC)
p_AE_pneumonia_BSC <- 0.016995273
p_AE_hypertension_BSC <- 0.012491647
p_AE_anaemia_BSC <- 0.013619484
p_AE_thrombocytopenia_BSC <- 0.018117967
p_AE_hyperglycaemia_BSC <- 0.0034224
p_AE_GGT_increased_BSC <- 0.0034224
p_AE_diarrhoea_BSC <- 0.002282904
p_AE_AE8_BSC <- 0.000
p_AE_AE9_BSC <- 0.000
p_AE_AE10_BSC <- 0.000
p_AE_AE11_BSC <- 0.000


# -----------------------------------------------------
# Unit Costs for Outpatient Management of AEs
# -----------------------------------------------------
c_AE_pneumonia_outpatient <- 371.768
c_AE_hypertension_outpatient <- 447.730
c_AE_anaemia_outpatient <- 394.642
c_AE_thrombocytopenia_outpatient <- 442.712
c_AE_hyperglycaemia_outpatient <- 485.777
c_AE_GGT_increased_outpatient <- 485.777
c_AE_diarrhoea_outpatient <- 388.046
c_AE_AE8_outpatient <- 0
c_AE_AE9_outpatient <- 0
c_AE_AE10_outpatient <- 0
c_AE_AE11_outpatient <- 0

# -----------------------------------------------------
# Unit Costs for Inpatient Management of AEs
# -----------------------------------------------------
c_AE_pneumonia_inpatient <- 3344.581
c_AE_hypertension_inpatient <- 1478.830
c_AE_anaemia_inpatient <- 1371.608
c_AE_thrombocytopenia_inpatient <- 1972.554
c_AE_hyperglycaemia_inpatient <- 767.985
c_AE_GGT_increased_inpatient <- 767.985
c_AE_diarrhoea_inpatient <- 3484.009
c_AE_AE8_inpatient <- 0
c_AE_AE9_inpatient <- 0
c_AE_AE10_inpatient <- 0
c_AE_AE11_inpatient <- 0



health.utility.method <- "SGRQ based (CLAD)"
age.adjusted.utility.values <- "Yes"

# -----------------------------------------------------
# SGRQ Scores Derived (Mapped to EQ-5D-3L)
# -----------------------------------------------------
SGRQ_clad0 <- 38  # Score for CLAD 0
SGRQ_clad1 <- 38  # Score for CLAD 1
SGRQ_clad2 <- 38  # Score for CLAD 2
SGRQ_clad3 <- 63  # Score for CLAD 3
SGRQ_clad4 <- 63  # Score for CLAD 4
SGRQ_LTx <- 54.67  # Score for LTx

include.utility.adjustment <- "No"
include_AE_disutility <- "Include"
disutility_pneumonia <- -0.195
disutility_hypertension <- -0.020
disutility_anaemia <- -0.900
disutility_thrombocytopenia <- -0.110
disutility_hyperglycaemia <- 0
disutility_GGT_increased <- 0
disutility_diarrhoea <- -0.176
disutility_AE8 <- 0
disutility_AE9 <- 0
disutility_AE10 <- 0
disutility_AE11 <- 0

duration_days_pneumonia <- 14.7
duration_days_hypertension <- 21.0
duration_days_anaemia <- 23.2
duration_days_thrombocytopenia <- 23.2
duration_days_hyperglycaemia <- 0
duration_days_GGT_increased <- 0
duration_days_diarrhoea <- 7
duration_days_AE8 <- 0
duration_days_AE9 <- 0
duration_days_AE10 <- 0
duration_days_AE11 <- 0










###########################################################
###########################################################
###########################################################
###########################################################


# -----------------------------------------------------
# Function Definition
# -----------------------------------------------------

# Function to calculate a weighted value based on BOS and RAS incidence
calculate_weighted_value <- function(value_BOS, value_RAS, p_incidence_BOS, p_incidence_RAS) {
  # Weighted sum of values using probabilities for BOS and RAS
  return((value_BOS * p_incidence_BOS) + (value_RAS * p_incidence_RAS))
}

# -----------------------------------------------------
# Weighted Value Calculations
# -----------------------------------------------------

# Calculate weighted annual FEV1 decline for year 1
n_declineFEV1.year1 <- calculate_weighted_value(
  n_declineFEV1.year1_BOS, 
  n_declineFEV1.year1_RAS, 
  p_incidence_BOS, 
  p_incidence_RAS
)

# Calculate weighted annual FEV1 decline for subsequent years
n_declineFEV1.subsequent <- calculate_weighted_value(
  n_declineFEV1.subsequent_BOS, 
  n_declineFEV1.subsequent_RAS, 
  p_incidence_BOS, 
  p_incidence_RAS
)

# Calculate weighted baseline FEV1
n_baselineFEV1 <- calculate_weighted_value(
  n_baselineFEV1_BOS, 
  n_baselineFEV1_RAS, 
  p_incidence_BOS, 
  p_incidence_RAS
)

# Calculate weighted relative risk of decline with Belumosudil
rr_decline_belumosudil <- calculate_weighted_value(
  rr_decline_belumosudil_BOS, 
  rr_decline_belumosudil_RAS, 
  p_incidence_BOS, 
  p_incidence_RAS
)

# -----------------------------------------------------
# Belumosudil Effects on FEV1 Decline
# -----------------------------------------------------

# Adjust annual FEV1 decline (year 1) accounting for Belumosudil effect
n_declineFEV1.year1_belumosudil <- n_declineFEV1.year1 * (1 - rr_decline_belumosudil)

# Adjust annual FEV1 decline (subsequent years) accounting for Belumosudil effect
n_declineFEV1.subsequent_belumosudil <- n_declineFEV1.subsequent * (1 - rr_decline_belumosudil)

# -----------------------------------------------------
# Baseline Decline Percentage Calculations
# -----------------------------------------------------

# List of decline percentage ranges based on baseline Clad levels
decline_percentages <- list(
  c(0.65, 0.80),  # For n_baseline.clad == 1
  c(0.50, 0.65),  # For n_baseline.clad == 2
  c(0.35, 0.50),  # For n_baseline.clad == 3
  c(0, 0.35)      # For n_baseline.clad == 4
)

# Assign the average decline percentage based on baseline Clad level
n_baseline.decline.percentage <- mean(decline_percentages[[n_baseline.clad]])

# Calculate the adjusted baseline FEV1 value for Clad0
n_baselineFEV1.clad0 <- n_baselineFEV1 / n_baseline.decline.percentage

# -----------------------------------------------------
# Survival DataFrame Construction
# -----------------------------------------------------

# Create a data frame to store survival data over the defined time horizon
df_survivaldata <- data.frame(
  Year = c(0:(12 * time_horizon) / 12)  # Define yearly time points
) %>%
  # Add additional time-related variables
  mutate(
    Week = Year * 52,                   # Convert years to weeks
    Days = Week * 7,                    # Convert weeks to days
    Cycle = c(0:(12 * time_horizon)),   # Define cycles (monthly units)
    Age = mean_age + Year               # Calculate patient age over time
  )





# Read survival coefficients from an Excel file
# This file contains the parameters required to define survival functions
# based on different distributions (Log-normal, Exponential, Weibull, etc.).
survival_coeff_clad <- read_excel("~/survival_coeff_clad.xlsx")

# Define survival distributions based on the specified type in survival_function
if (survival_function == "Log-normal") {
  # Log-normal distribution: defined by the parameters meanlog and sdlog
  # BOS: Parameters are directly retrieved from the survival coefficients
  surv_dist_BOS <- define_surv_dist(
    distribution = "lnorm",
    meanlog = as.numeric(
      survival_coeff_clad %>% filter(Variable == "meanlog") %>% select(Log.normal)
    ),
    sdlog = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "sdlog") %>% select(Log.normal)
    ))
  )
  
  # RAS: Includes the RxB coefficient to adjust survival outcomes
  surv_dist_RAS <- define_surv_dist(
    distribution = "lnorm",
    meanlog = as.numeric(
      survival_coeff_clad %>% filter(Variable == "meanlog") %>% select(Log.normal)
      + survival_coeff_clad %>% filter(Variable == "RxB") %>% select(Log.normal)
    ),
    sdlog = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "sdlog") %>% select(Log.normal)
    ))
  )
}

# Exponential distribution: defined by a single rate parameter
if (survival_function == "Exponential") {
  # BOS: The rate parameter is calculated using the log.scale coefficient
  surv_dist_BOS <- define_surv_dist(
    distribution = "exp",
    rate = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.scale") %>% select(Exponential)
    ))
  )
  
  # RAS: The RxB coefficient is added to adjust the rate
  surv_dist_RAS <- define_surv_dist(
    distribution = "exp",
    rate = as.numeric(
      exp(
        survival_coeff_clad %>% filter(Variable == "log.scale") %>% select(Exponential) +
          survival_coeff_clad %>% filter(Variable == "RxB") %>% select(Exponential)
      )
    )
  )
}

# General gamma distribution: defined by mu, sigma, and Q parameters
if (survival_function == "General gamma") {
  # BOS: Retrieve parameters directly from survival coefficients
  surv_dist_BOS <- define_surv_dist(
    distribution = "gengamma",
    mu = as.numeric(
      survival_coeff_clad %>% filter(Variable == "mu") %>% select(General.gamma)
    ),
    sigma = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.sigma") %>% select(General.gamma)
    )),
    Q = as.numeric(
      survival_coeff_clad %>% filter(Variable == "Q") %>% select(General.gamma)
    )
  )
  
  # RAS: Adjust the mu parameter by adding the RxB coefficient
  surv_dist_RAS <- define_surv_dist(
    distribution = "gengamma",
    mu = as.numeric(
      survival_coeff_clad %>% filter(Variable == "mu") %>% select(General.gamma)
    ) + as.numeric(
      survival_coeff_clad %>% filter(Variable == "RxB") %>% select(General.gamma)
    ),
    sigma = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.sigma") %>% select(General.gamma)
    )),
    Q = as.numeric(
      survival_coeff_clad %>% filter(Variable == "Q") %>% select(General.gamma)
    )
  )
}

# Gompertz distribution: defined by rate and shape parameters
if (survival_function == "Gompertz") {
  # BOS: Retrieve rate and shape parameters from survival coefficients
  surv_dist_BOS <- define_surv_dist(
    distribution = "gompertz",
    rate = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.rate") %>% select(Gompertz)
    )),
    shape = as.numeric(
      survival_coeff_clad %>% filter(Variable == "shape") %>% select(Gompertz)
    )
  )
  
  # RAS: Adjust the rate parameter by adding the RxB coefficient
  surv_dist_RAS <- define_surv_dist(
    distribution = "gompertz",
    rate = as.numeric(
      exp(
        survival_coeff_clad %>% filter(Variable == "log.rate") %>% select(Gompertz) +
          survival_coeff_clad %>% filter(Variable == "RxB") %>% select(Gompertz)
      )
    ),
    shape = as.numeric(
      survival_coeff_clad %>% filter(Variable == "shape") %>% select(Gompertz)
    )
  )
}

# Log-logistic distribution: defined by shape and scale parameters
if (survival_function == "Log-logistic") {
  # BOS: Retrieve shape and scale parameters from survival coefficients
  surv_dist_BOS <- define_surv_dist(
    distribution = "llogis",
    shape = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.shape") %>% select(Log.logistic)
    )),
    scale = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.scale") %>% select(Log.logistic)
    ))
  )
  
  # RAS: Adjust the scale parameter by adding the RxB coefficient
  surv_dist_RAS <- define_surv_dist(
    distribution = "llogis",
    shape = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.shape") %>% select(Log.logistic)
    )),
    scale = as.numeric(
      exp(
        survival_coeff_clad %>% filter(Variable == "log.scale") %>% select(Log.logistic)
        + survival_coeff_clad %>% filter(Variable == "RxB") %>% select(Log.logistic)
      )
    )
  )
}

# Weibull distribution: defined by shape and scale parameters
if (survival_function == "Weibull") {
  # BOS: Retrieve shape and scale parameters from survival coefficients
  surv_dist_BOS <- define_surv_dist(
    distribution = "weibull",
    shape = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.shape") %>% select(Weibull)
    )),
    scale = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.scale") %>% select(Weibull)
    ))
  )
  
  # RAS: Adjust the scale parameter by adding the RxB coefficient
  surv_dist_RAS <- define_surv_dist(
    distribution = "weibull",
    shape = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.shape") %>% select(Weibull)
    )),
    scale = as.numeric(
      exp(
        survival_coeff_clad %>% filter(Variable == "log.scale") %>% select(Weibull) +
          survival_coeff_clad %>% filter(Variable == "RxB") %>% select(Weibull)
      )
    )
  )
}

# Gamma distribution: defined by shape and rate parameters
if (survival_function == "Gamma") {
  # BOS: Retrieve shape and rate parameters from survival coefficients
  surv_dist_BOS <- define_surv_dist(
    distribution = "gamma",
    shape = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.shape") %>% select(Gamma)
    )),
    rate = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.scale") %>% select(Gamma)
    ))
  )
  
  # RAS: Adjust the rate parameter by adding the RxB coefficient
  surv_dist_RAS <- define_surv_dist(
    distribution = "gamma",
    shape = as.numeric(exp(
      survival_coeff_clad %>% filter(Variable == "log.shape") %>% select(Gamma)
    )),
    rate = as.numeric(
      exp(
        survival_coeff_clad %>% filter(Variable == "log.scale") %>% select(Gamma) +
          survival_coeff_clad %>% filter(Variable == "RxB") %>% select(Gamma)
      )
    )
  )
}

# Check if the survival function is defined as "Spline Knot 1"
if (survival_function == "Spline Knot 1") {
  
  # Define the survival distribution for the BOS (Baseline) model using a spline with knots
  surv_dist_BOS <- define_surv_spline(
    scale = "hazard",  # Set the scale to 'hazard'
    gamma = as.numeric(  # Specify the coefficients for the gamma parameters
      c(
        # Extract and assign values for gamma0, gamma1, and gamma2 from the coefficients table for Spline1
        survival_coeff_clad %>% filter(Variable == "gamma0") %>% select(Spline1),
        survival_coeff_clad %>% filter(Variable == "gamma1") %>% select(Spline1),
        survival_coeff_clad %>% filter(Variable == "gamma2") %>% select(Spline1)
      )
    ),
    knots = as.numeric(  # Specify the values for the knots in the spline
      c(
        # Extract and assign values for the knots from the coefficients table for Spline1
        survival_coeff_clad %>% filter(Variable == "knot1") %>% select(Spline1),
        survival_coeff_clad %>% filter(Variable == "knot2") %>% select(Spline1),
        survival_coeff_clad %>% filter(Variable == "knot3") %>% select(Spline1)
      )
    )
  )
  
  # Define the survival distribution for the RAS (Risk Adjustment) model using a spline with knots
  surv_dist_RAS <- define_surv_spline(
    scale = "hazard",  # Set the scale to 'hazard'
    gamma = as.numeric(  # Specify the coefficients for the gamma parameters
      c(
        # Adjust the gamma0 coefficient by adding RxB interaction term for Spline1
        survival_coeff_clad %>% filter(Variable == "gamma0") %>% select(Spline1) + 
          survival_coeff_clad %>% filter(Variable == "RxB") %>% select(Spline1),
        # Extract values for gamma1 and gamma2 from the coefficients table for Spline1
        survival_coeff_clad %>% filter(Variable == "gamma1") %>% select(Spline1),
        survival_coeff_clad %>% filter(Variable == "gamma2") %>% select(Spline1)
      )
    ),
    knots = as.numeric(  # Specify the values for the knots in the spline
      c(
        # Extract and assign values for the knots from the coefficients table for Spline1
        survival_coeff_clad %>% filter(Variable == "knot1") %>% select(Spline1),
        survival_coeff_clad %>% filter(Variable == "knot2") %>% select(Spline1),
        survival_coeff_clad %>% filter(Variable == "knot3") %>% select(Spline1)
      )
    )
  )
}

# Check if the survival function is defined as "Spline Knot 2"
if (survival_function == "Spline Knot 2") {
  
  # Define the survival distribution for the BOS (Baseline) model using a spline with knots
  surv_dist_BOS <- define_surv_spline(
    scale = "hazard",  # Set the scale to 'hazard'
    gamma = as.numeric(  # Specify the coefficients for the gamma parameters
      c(
        # Extract and assign values for gamma0, gamma1, gamma2, and gamma3 from the coefficients table for Spline2
        survival_coeff_clad %>% filter(Variable == "gamma0") %>% select(Spline2),
        survival_coeff_clad %>% filter(Variable == "gamma1") %>% select(Spline2),
        survival_coeff_clad %>% filter(Variable == "gamma2") %>% select(Spline2),
        survival_coeff_clad %>% filter(Variable == "gamma3") %>% select(Spline2)
      )
    ),
    knots = as.numeric(  # Specify the values for the knots in the spline
      c(
        # Extract and assign values for the knots from the coefficients table for Spline2
        survival_coeff_clad %>% filter(Variable == "knot1") %>% select(Spline2),
        survival_coeff_clad %>% filter(Variable == "knot2") %>% select(Spline2),
        survival_coeff_clad %>% filter(Variable == "knot3") %>% select(Spline2),
        survival_coeff_clad %>% filter(Variable == "knot4") %>% select(Spline2)
      )
    )
  )
  
  # Define the survival distribution for the RAS (Risk Adjustment) model using a spline with knots
  surv_dist_RAS <- define_surv_spline(
    scale = "hazard",  # Set the scale to 'hazard'
    gamma = as.numeric(  # Specify the coefficients for the gamma parameters
      c(
        # Adjust the gamma0 coefficient by adding RxB interaction term for Spline2
        survival_coeff_clad %>% filter(Variable == "gamma0") %>% select(Spline2) + 
          survival_coeff_clad %>% filter(Variable == "RxB") %>% select(Spline2),
        # Extract values for gamma1, gamma2, and gamma3 from the coefficients table for Spline2
        survival_coeff_clad %>% filter(Variable == "gamma1") %>% select(Spline2),
        survival_coeff_clad %>% filter(Variable == "gamma2") %>% select(Spline2),
        survival_coeff_clad %>% filter(Variable == "gamma3") %>% select(Spline2)
      )
    ),
    knots = as.numeric(  # Specify the values for the knots in the spline
      c(
        # Extract and assign values for the knots from the coefficients table for Spline2
        survival_coeff_clad %>% filter(Variable == "knot1") %>% select(Spline2),
        survival_coeff_clad %>% filter(Variable == "knot2") %>% select(Spline2),
        survival_coeff_clad %>% filter(Variable == "knot3") %>% select(Spline2),
        survival_coeff_clad %>% filter(Variable == "knot4") %>% select(Spline2)
      )
    )
  )
}

# Check if the survival function is defined as "Spline Knot 3"
if (survival_function == "Spline Knot 3") {
  
  # Define the survival distribution for the BOS (Baseline) model using a spline with knots
  surv_dist_BOS <- define_surv_spline(
    scale = "hazard",  # Set the scale to 'hazard'
    gamma = as.numeric(  # Specify the coefficients for the gamma parameters
      c(
        # Extract and assign values for gamma0, gamma1, gamma2, gamma3, and gamma4 from the coefficients table for Spline3
        survival_coeff_clad %>% filter(Variable == "gamma0") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "gamma1") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "gamma2") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "gamma3") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "gamma4") %>% select(Spline3)
      )
    ),
    knots = as.numeric(  # Specify the values for the knots in the spline
      c(
        # Extract and assign values for the knots from the coefficients table for Spline3
        survival_coeff_clad %>% filter(Variable == "knot1") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "knot2") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "knot3") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "knot4") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "knot5") %>% select(Spline3)
      )
    )
  )
  
  # Define the survival distribution for the RAS (Risk Adjustment) model using a spline with knots
  surv_dist_RAS <- define_surv_spline(
    scale = "hazard",  # Set the scale to 'hazard'
    gamma = as.numeric(  # Specify the coefficients for the gamma parameters
      c(
        # Adjust the gamma0 coefficient by adding RxB interaction term for Spline3
        survival_coeff_clad %>% filter(Variable == "gamma0") %>% select(Spline3) + 
          survival_coeff_clad %>% filter(Variable == "RxB") %>% select(Spline3),
        # Extract values for gamma1, gamma2, gamma3, and gamma4 from the coefficients table for Spline3
        survival_coeff_clad %>% filter(Variable == "gamma1") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "gamma2") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "gamma3") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "gamma4") %>% select(Spline3)
      )
    ),
    knots = as.numeric(  # Specify the values for the knots in the spline
      c(
        # Extract and assign values for the knots from the coefficients table for Spline3
        survival_coeff_clad %>% filter(Variable == "knot1") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "knot2") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "knot3") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "knot4") %>% select(Spline3),
        survival_coeff_clad %>% filter(Variable == "knot5") %>% select(Spline3)
      )
    )
  )
}


# Function to compute survival based on the provided survival distribution
compute_survival <- function(surv_dist, cycle_length, time, type) {
  # Calls a helper function 'compute_surv' that calculates survival
  # based on the distribution, cycle length, time steps, and type (survival or other types)
  return(compute_surv(surv_dist, cycle_length = cycle_length, time = time, type = type))
}

# Calculate survival for both BOS and RAS 
survival_BOS <- compute_survival(
  surv_dist = surv_dist_BOS, 
  cycle_length = df_survivaldata$Days[2], 
  time = 1:length(df_survivaldata$Days) - 1, 
  type = "survival"
)

survival_RAS <- compute_survival(
  surv_dist = surv_dist_RAS, 
  cycle_length = df_survivaldata$Days[2], 
  time = 1:length(df_survivaldata$Days) - 1, 
  type = "survival"
)

# Create a dataframe to store survival data for both BOS and RAS
survival_phenotypes <- data.frame(
  S.t_BOS.BSC = survival_BOS, 
  S.t_RAS.BSC = survival_RAS
)

# Function to calculate hazard from survival
calc_hazard <- function(S_t) {
  # Hazard is calculated as the change in the log of survival between consecutive time points
  return(-log(S_t) - (-log(lag(S_t, default = 1))))
}

# Function to calculate survival from the hazard values
calc_survival <- function(hazard) {
  # Survival is computed as the exponential of the negative cumulative sum of the hazard
  return(exp(-cumsum(hazard)))
}

# Function to apply a risk factor (e.g., hazard ratio) to the hazard values
apply_risk_factor <- function(hazard, hr_factor) {
  # Apply the risk factor to the hazard, scaling it accordingly
  return(hazard * hr_factor)
}

# Apply the survival and hazard calculations to the dataframe
df_survivaldata <- df_survivaldata %>%
  bind_cols(survival_phenotypes[1:(12 * time_horizon + 1), ]) %>%  # Add survival phenotype columns to the dataframe
  mutate(
    # Calculate overall survival (S.t_Overall.BSC) as a weighted average of BOS and RAS survival
    # The weights are based on the incidence of BOS (p_incidence_BOS)
    S.t_Overall.BSC = S.t_BOS.BSC * p_incidence_BOS + S.t_RAS.BSC * (1 - p_incidence_BOS),
    
    # Calculate the hazard for each survival model (BOS, RAS, and overall)
    h.t_BOS.BSC = calc_hazard(S.t_BOS.BSC),
    h.t_RAS.BSC = calc_hazard(S.t_RAS.BSC),
    h.t_Overall.BSC = calc_hazard(S.t_Overall.BSC),
    
    # Apply the Belumosudil risk factor to the hazard values for BOS, RAS, and overall survival
    h.t_BOS.belumosudil = apply_risk_factor(h.t_BOS.BSC, hr_belumosudil),
    h.t_RAS.belumosudil = apply_risk_factor(h.t_RAS.BSC, hr_belumosudil),
    h.t_Overall.belumosudil = apply_risk_factor(h.t_Overall.BSC, hr_belumosudil),
    
    # Calculate survival from the adjusted hazard values (with Belumosudil treatment)
    S.t_BOS.belumosudil = calc_survival(h.t_BOS.belumosudil),
    S.t_RAS.belumosudil = calc_survival(h.t_RAS.belumosudil),
    S.t_Overall.belumosudil = calc_survival(h.t_Overall.belumosudil)
  ) %>%
  mutate(
    # Calculate survival for different clad stage
    # Each stage represents a different disease stage, and survival is adjusted based on the corresponding risk factor (e.g., hr_clad1)
    
    # Stage 1 Clad
    S.t_clad1.belumosudil = calc_survival(h.t_Overall.belumosudil * hr_clad1),
    S.t_clad1.BSC = calc_survival(h.t_Overall.BSC * hr_clad1),
    
    # Stage 2 Clad
    S.t_clad2.belumosudil = calc_survival(h.t_Overall.belumosudil * hr_clad2),
    S.t_clad2.BSC = calc_survival(h.t_Overall.BSC * hr_clad2),
    
    # Stage 3 Clad
    S.t_clad3.belumosudil = calc_survival(h.t_Overall.belumosudil * hr_clad3),
    S.t_clad3.BSC = calc_survival(h.t_Overall.BSC * hr_clad3),
    
    # Stage 4 Clad
    S.t_clad4.belumosudil = calc_survival(h.t_Overall.belumosudil * hr_clad4),
    S.t_clad4.BSC = calc_survival(h.t_Overall.BSC * hr_clad4)
  )


############################################################################"


# Function to calculate FEV1 (Forced Expiratory Volume in 1 second) for each treatment (Belumosudil and BSC)
calculate_FEV1 <- function(df_survivaldata, baseline_FEV1, decline_year1, decline_subsequent, time_horizon) {
  # Calculate FEV1 for the first year with decline rate 'decline_year1'
  # Then, calculate FEV1 for the subsequent years with decline rate 'decline_subsequent'
  FEV1 <- c(
    baseline_FEV1 - df_survivaldata$Cycle[1:13] * decline_year1,
    baseline_FEV1 - df_survivaldata$Cycle[14:(12 * time_horizon + 1)] * decline_subsequent
  )
  # Ensure that FEV1 values do not go below 0
  FEV1[which(FEV1 < 0)] <- 0
  return(FEV1)
}

# Function to calculate the change in FEV1 from baseline for each treatment
calculate_FEV1_changes <- function(FEV1, baseline_FEV1_clad0) {
  # Calculate the relative change in FEV1 from baseline (Clad0)
  return((baseline_FEV1_clad0 - FEV1) / baseline_FEV1_clad0)
}

# Function to calculate the CLAD (Chronic Lung Allograft Dysfunction) stage based on the change in FEV1
calculate_CLAD_stages <- function(change_FEV1) {
  # Create an empty vector to store CLAD stage values
  CLAD_stage <- rep(NA, length(change_FEV1))
  
  # Assign CLAD stage based on the percentage change in FEV1
  CLAD_stage[which(change_FEV1 < 0.35)] <- 1
  CLAD_stage[which(change_FEV1 >= 0.35 & change_FEV1 < 0.5)] <- 2
  CLAD_stage[which(change_FEV1 >= 0.5 & change_FEV1 < 0.65)] <- 3
  CLAD_stage[which(change_FEV1 >= 0.65)] <- 4
  
  return(CLAD_stage)
}

# Function to calculate the probability of lung transplantation (LTx) based on CLAD stage
calculate_LTx_probabilities <- function(CLAD_stage, p_LTx_clad) {
  # Initialize a vector for transplantation probabilities
  probability_LTx <- rep(NA, length(CLAD_stage))
  
  # Assign LTx probabilities based on CLAD stages
  probability_LTx[which(CLAD_stage == 1) + 1] <- p_LTx_clad$clad1
  probability_LTx[which(CLAD_stage == 2) + 1] <- p_LTx_clad$clad2
  probability_LTx[which(CLAD_stage == 3) + 1] <- p_LTx_clad$clad3
  probability_LTx[which(CLAD_stage == 4)] <- p_LTx_clad$clad4
  
  # No transplantation probability for the initial stage (before CLAD development)
  probability_LTx[1] <- 0
  return(probability_LTx)
}

# Function to calculate the probability of treatment discontinuation (disc) based on CLAD stage
calculate_disc_probabilities <- function(CLAD_stage, p_disc_clad, p_stoprule_clad) {
  # Initialize a vector for discontinuation probabilities
  probability_disc <- rep(NA, length(CLAD_stage))
  
  # Assign discontinuation probabilities based on CLAD stages
  probability_disc[which(CLAD_stage == 1) + 1] <- min(1, p_disc_clad + p_stoprule_clad$clad1)
  probability_disc[which(CLAD_stage == 2) + 1] <- min(1, p_disc_clad + p_stoprule_clad$clad2)
  probability_disc[which(CLAD_stage == 3) + 1] <- min(1, p_disc_clad + p_stoprule_clad$clad3)
  probability_disc[which(CLAD_stage == 4)] <- min(1, p_disc_clad + p_stoprule_clad$clad4)
  
  # No discontinuation probability before CLAD development
  probability_disc[1] <- 0
  return(probability_disc)
}

# Using the above functions to create the main DataFrame with FEV1 trajectory and probabilities

# Calculate FEV1 values for both Belumosudil and BSC treatments over time
df_FEV1trajectory <- as.data.frame(df_survivaldata$Cycle) %>%
  mutate(
    # FEV1 values for Belumosudil treatment using the provided decline rates
    FEV1.belumosudil = calculate_FEV1(df_survivaldata, n_baselineFEV1, n_declineFEV1.year1_belumosudil, n_declineFEV1.subsequent_belumosudil, time_horizon),
    
    # FEV1 values for BSC treatment using the provided decline rates
    FEV1.BSC = calculate_FEV1(df_survivaldata, n_baselineFEV1, n_declineFEV1.year1, n_declineFEV1.subsequent, time_horizon)
  )

# Calculate the relative change in FEV1 for both treatments from baseline FEV1 (Clad0)
df_FEV1trajectory$Change.FEV1.belumosudil <- calculate_FEV1_changes(df_FEV1trajectory$FEV1.belumosudil, n_baselineFEV1.clad0)
df_FEV1trajectory$Change.FEV1.BSC <- calculate_FEV1_changes(df_FEV1trajectory$FEV1.BSC, n_baselineFEV1.clad0)

# Determine the CLAD stage for each treatment based on the change in FEV1
df_FEV1trajectory$CLAD.stage.belumosudil <- calculate_CLAD_stages(df_FEV1trajectory$Change.FEV1.belumosudil)
df_FEV1trajectory$CLAD.stage.BSC <- calculate_CLAD_stages(df_FEV1trajectory$Change.FEV1.BSC)

# Calculate the probability of lung transplantation (LTx) for both treatments based on CLAD stage
df_FEV1trajectory$probability_LTx_belumosudil <- calculate_LTx_probabilities(df_FEV1trajectory$CLAD.stage.belumosudil, 
                                                                             list(clad1 = p_LTx_clad1_belumosudil, clad2 = p_LTx_clad2_belumosudil, clad3 = p_LTx_clad3_belumosudil, clad4 = p_LTx_clad4_belumosudil))

df_FEV1trajectory$probability_LTx_BSC <- calculate_LTx_probabilities(df_FEV1trajectory$CLAD.stage.BSC, 
                                                                     list(clad1 = p_LTx_clad1_BSC, clad2 = p_LTx_clad2_BSC, clad3 = p_LTx_clad3_BSC, clad4 = p_LTx_clad4_BSC))

# Calculate the probability of treatment discontinuation (disc) for both treatments based on CLAD stage
df_FEV1trajectory$probability_disc_belumosudil <- calculate_disc_probabilities(df_FEV1trajectory$CLAD.stage.belumosudil, 
                                                                               p_disc_belumosudil, list(clad1 = p_stoprule_clad1, clad2 = p_stoprule_clad2, clad3 = p_stoprule_clad3, clad4 = p_stoprule_clad4))




disc_rank_list <- lapply(2:nrow(df_FEV1trajectory), function(i) rep(NA, nrow(df_FEV1trajectory)))

names(disc_rank_list) <- paste0("disc_rank.", 2:nrow(df_FEV1trajectory))


for (i in 1:(nrow(df_FEV1trajectory)-1)) {
  
  disc_rank_list[[i]][1:((i+1)-1)]  <- df_FEV1trajectory$FEV1.belumosudil[1:((i+1)-1)]
  
  disc_rank_list[[i]] [(i+1):nrow(df_FEV1trajectory)] <- df_FEV1trajectory$FEV1.belumosudil[(i+1)-1] - n_declineFEV1.subsequent*c(1:( nrow(df_FEV1trajectory)- i))
  
  disc_rank_list[[i]] [which(disc_rank_list[[i]]<0)] <- 0
  
} 

df_disc_rank_list <- as.data.frame(disc_rank_list) %>% mutate(Cycle = df_FEV1trajectory$`df_survivaldata$Cycle`)


###########################################################################################

# Load general mortality data from an Excel file
general_mortality <- read_excel("~/general_mortality.xlsx")

# Filter the dataset to include only rows where Age is greater than (mean_age - 1)
general_mortality <- general_mortality %>% 
  filter(Age > mean_age - 1)


# Initialize a new column for belumosudil cycle-specific mortality probabilities in df_survivaldata
df_survivaldata$p_cycle_mortality_belumosudil <- rep(NA, nrow(df_survivaldata))


# Calculate mortality probabilities for belumosudil when CLAD stage = 1
df_survivaldata$p_cycle_mortality_belumosudil[1:last(which(df_FEV1trajectory$CLAD.stage.belumosudil == 1))] <- 
  (1 - df_survivaldata$S.t_clad1.belumosudil / lag(df_survivaldata$S.t_clad1.belumosudil))[1:length(which(df_FEV1trajectory$CLAD.stage.belumosudil == 1))]

# Calculate mortality probabilities for belumosudil when CLAD stage = 2
df_survivaldata$p_cycle_mortality_belumosudil[first(which(df_FEV1trajectory$CLAD.stage.belumosudil == 2)):last(which(df_FEV1trajectory$CLAD.stage.belumosudil == 2))] <- 
  as.vector(na.omit((1 - df_survivaldata$S.t_clad2.belumosudil / lag(df_survivaldata$S.t_clad2.belumosudil))[1:(length(which(df_FEV1trajectory$CLAD.stage.belumosudil == 2)) + 1)]))

# Calculate mortality probabilities for belumosudil when CLAD stage = 3
df_survivaldata$p_cycle_mortality_belumosudil[first(which(df_FEV1trajectory$CLAD.stage.belumosudil == 3)):last(which(df_FEV1trajectory$CLAD.stage.belumosudil == 3))] <- 
  as.vector(na.omit((1 - df_survivaldata$S.t_clad3.belumosudil / lag(df_survivaldata$S.t_clad3.belumosudil))[1:(length(which(df_FEV1trajectory$CLAD.stage.belumosudil == 3)) + 1)]))

# Calculate mortality probabilities for belumosudil when CLAD stage = 4
df_survivaldata$p_cycle_mortality_belumosudil[first(which(df_FEV1trajectory$CLAD.stage.belumosudil == 4)):last(which(df_FEV1trajectory$CLAD.stage.belumosudil == 4))] <- 
  as.vector(na.omit((1 - df_survivaldata$S.t_clad4.belumosudil / lag(df_survivaldata$S.t_clad4.belumosudil))[1:(length(which(df_FEV1trajectory$CLAD.stage.belumosudil == 4)) + 1)]))

# Assign a mortality probability of 1 to patients aged 100 or more
df_survivaldata$p_cycle_mortality_belumosudil[which(df_survivaldata$Age >= 100)] <- 1

# Set the first cycle's mortality probability to 0 (baseline)
df_survivaldata$p_cycle_mortality_belumosudil[1] <- 0





# Initialize a new column for BSC cycle-specific mortality probabilities in df_survivaldata
df_survivaldata$p_cycle_mortality_BSC <- rep(NA, nrow(df_survivaldata))


# Calculate mortality probabilities for BSC when CLAD stage = 1
df_survivaldata$p_cycle_mortality_BSC[1:last(which(df_FEV1trajectory$CLAD.stage.BSC == 1))] <- 
  (1 - (df_survivaldata$S.t_clad1.BSC / lag(df_survivaldata$S.t_clad1.BSC)))[1:length(which(df_FEV1trajectory$CLAD.stage.BSC == 1))]

# Calculate mortality probabilities for BSC when CLAD stage = 2
df_survivaldata$p_cycle_mortality_BSC[first(which(df_FEV1trajectory$CLAD.stage.BSC == 2)):last(which(df_FEV1trajectory$CLAD.stage.BSC == 2))] <- 
  as.vector(na.omit((1 - (df_survivaldata$S.t_clad2.BSC / lag(df_survivaldata$S.t_clad2.BSC)))[1:(length(which(df_FEV1trajectory$CLAD.stage.BSC == 2)) + 1)]))

# Calculate mortality probabilities for BSC when CLAD stage = 3
df_survivaldata$p_cycle_mortality_BSC[first(which(df_FEV1trajectory$CLAD.stage.BSC == 3)):last(which(df_FEV1trajectory$CLAD.stage.BSC == 3))] <- 
  as.vector(na.omit((1 - (df_survivaldata$S.t_clad3.BSC / lag(df_survivaldata$S.t_clad3.BSC)))[1:(length(which(df_FEV1trajectory$CLAD.stage.BSC == 3)) + 1)]))

# Calculate mortality probabilities for BSC when CLAD stage = 4
df_survivaldata$p_cycle_mortality_BSC[first(which(df_FEV1trajectory$CLAD.stage.BSC == 4)):last(which(df_FEV1trajectory$CLAD.stage.BSC == 4))] <- 
  as.vector(na.omit((1 - (df_survivaldata$S.t_clad4.BSC / lag(df_survivaldata$S.t_clad4.BSC)))[1:(length(which(df_FEV1trajectory$CLAD.stage.BSC == 4)) + 1)]))

# Assign a mortality probability of 1 to patients aged 100 or more
df_survivaldata$p_cycle_mortality_BSC[which(df_survivaldata$Age >= 100)] <- 1

# Set the first cycle's mortality probability to 0 (baseline)
df_survivaldata$p_cycle_mortality_BSC[1] <- 0






# Initialize a new column for LTx cycle-specific mortality probabilities in df_survivaldata
df_survivaldata$p_cycle_mortality_LTx <- rep(NA, nrow(df_survivaldata))

# Calculate mortality probabilities for lung transplant (LTx) cycles based on averaged survival across CLAD stages
df_survivaldata$p_cycle_mortality_LTx <- 
  1 - (rowMeans(
    cbind(
      df_survivaldata$S.t_clad1.BSC,
      df_survivaldata$S.t_clad2.BSC,
      df_survivaldata$S.t_clad3.BSC
    )
  ) / rowMeans(
    cbind(
      lag(df_survivaldata$S.t_clad1.BSC),
      lag(df_survivaldata$S.t_clad2.BSC),
      lag(df_survivaldata$S.t_clad3.BSC)
    )
  ))

# Set the first cycle's LTx mortality probability to 0 (baseline)
df_survivaldata$p_cycle_mortality_LTx[1] <- 0


##################################################################


# Initialize new columns in the df_FEV1trajectory dataframe with NA values
df_FEV1trajectory <- df_FEV1trajectory %>%
  mutate(
    Belumosudil.arm.1L = rep(NA, nrow(df_FEV1trajectory)),   # First-line treatment with Belumosudil
    Belumosudil.arm.2L.BSC = rep(NA, nrow(df_FEV1trajectory)), # Second-line treatment after Belumosudil, switching to BSC
    Belumosudil.arm.newly.2L.BSC = rep(NA, nrow(df_FEV1trajectory)), # Newly on BSC, Second-line treatment after Belumosudil
    Belumosudil.arm.LTx = rep(NA, nrow(df_FEV1trajectory)),  # Transition to lung transplant (LTx) under Belumosudil treatment
    Belumosudil.arm.Dead = rep(NA, nrow(df_FEV1trajectory)), # Death under Belumosudil treatment
    BSC.arm = rep(NA, nrow(df_FEV1trajectory)),              # Best Supportive of Care (BSC) treatment
    BSC.arm.LTx = rep(NA, nrow(df_FEV1trajectory)),          # Transition to lung transplant (LTx) under BSC treatment
    BSC.arm.Dead = rep(NA, nrow(df_FEV1trajectory))          # Death under BSC treatment
  )

# Initialize values for the first row
df_FEV1trajectory$Belumosudil.arm.1L[1] <- 1     # Start with all patients in first-line Belumosudil treatment
df_FEV1trajectory$Belumosudil.arm.2L.BSC[1] <- 0 # No patients initially in second-line treatment
df_FEV1trajectory$Belumosudil.arm.newly.2L.BSC[1] <- 0 
df_FEV1trajectory$Belumosudil.arm.LTx[1] <- 0    # No patients initially in the lung transplant group
df_FEV1trajectory$Belumosudil.arm.Dead[1] <- 0   # No patients initially deceased
df_FEV1trajectory$BSC.arm[1] <- 1                # All patients start in BSC for this arm
df_FEV1trajectory$BSC.arm.LTx[1] <- 0            # No patients initially in lung transplant group under BSC
df_FEV1trajectory$BSC.arm.Dead[1] <- 0           # No patients initially deceased in BSC arm

# Loop through each subsequent row to calculate transitions
for (i in 2:nrow(df_FEV1trajectory)) {
  # Transition probabilities for Belumosudil.arm.1L (remaining in first-line treatment)
  df_FEV1trajectory$Belumosudil.arm.1L[i] <- df_FEV1trajectory$Belumosudil.arm.1L[i - 1] *
    (1 - df_survivaldata$p_cycle_mortality_belumosudil[i]) *  # Survives this cycle
    (1 - df_FEV1trajectory$probability_LTx_belumosudil[i]) * # Does not transition to lung transplant
    (1 - df_FEV1trajectory$probability_disc_belumosudil[i])  # Does not discontinue Belumosudil
  
  # Transition probabilities for Belumosudil.arm.2L.BSC (discontinuation to second-line BSC)
  df_FEV1trajectory$Belumosudil.arm.2L.BSC[i] <- df_FEV1trajectory$Belumosudil.arm.1L[i - 1] *
    df_FEV1trajectory$probability_disc_belumosudil[i] *       # Patients discontinuing Belumosudil
    (1 - df_survivaldata$p_cycle_mortality_belumosudil[i]) *  # Survives this cycle
    (1 - df_FEV1trajectory$probability_LTx_belumosudil[i]) + # Does not transition to lung transplant
    df_FEV1trajectory$Belumosudil.arm.2L.BSC[i - 1] *
    (1 - df_survivaldata$p_cycle_mortality_BSC[i]) *         # Survives this cycle in BSC
    (1 - df_FEV1trajectory$probability_LTx_BSC[i])           # Does not transition to lung transplant
  
  
  
  # Transition probabilities for Belumosudil.arm.newly.2L.BSC
  df_FEV1trajectory$Belumosudil.arm.newly.2L.BSC[i] <- df_FEV1trajectory$Belumosudil.arm.1L[i-1]*
    df_FEV1trajectory$probability_disc_belumosudil[i] *
    (1 - df_survivaldata$p_cycle_mortality_belumosudil[i])*
    (1 - df_FEV1trajectory$probability_LTx_belumosudil[i])
  
  # Transition probabilities for Belumosudil.arm.LTx (transition to lung transplant)
  df_FEV1trajectory$Belumosudil.arm.LTx[i] <- df_FEV1trajectory$Belumosudil.arm.1L[i - 1] *
    (1 - df_survivaldata$p_cycle_mortality_belumosudil[i]) *  # Survives this cycle
    df_FEV1trajectory$probability_LTx_belumosudil[i] +       # Transitions to lung transplant
    df_FEV1trajectory$Belumosudil.arm.2L.BSC[i - 1] *
    (1 - df_survivaldata$p_cycle_mortality_BSC[i]) *         # Survives this cycle in second-line BSC
    df_FEV1trajectory$probability_LTx_BSC[i] +               # Transitions to lung transplant
    df_FEV1trajectory$Belumosudil.arm.LTx[i - 1] *
    (1 - df_survivaldata$p_cycle_mortality_LTx[i])           # Survives this cycle after lung transplant
  
  # Transition probabilities for Belumosudil.arm.Dead (death probabilities)
  df_FEV1trajectory$Belumosudil.arm.Dead[i] <- df_FEV1trajectory$Belumosudil.arm.Dead[i - 1] + 
    df_FEV1trajectory$Belumosudil.arm.1L[i - 1] *
    df_survivaldata$p_cycle_mortality_belumosudil[i] *       # Dies during first-line treatment
    (1 - df_FEV1trajectory$probability_LTx_belumosudil[i]) +
    df_FEV1trajectory$Belumosudil.arm.2L.BSC[i - 1] *
    df_survivaldata$p_cycle_mortality_BSC[i] *               # Dies during second-line treatment
    (1 - df_FEV1trajectory$probability_LTx_BSC[i]) +
    df_FEV1trajectory$Belumosudil.arm.LTx[i - 1] *
    df_survivaldata$p_cycle_mortality_LTx[i]                 # Dies post lung transplant
  
  # Transition probabilities for BSC.arm (remaining in BSC)
  df_FEV1trajectory$BSC.arm[i] <- df_FEV1trajectory$BSC.arm[i - 1] *
    (1 - df_FEV1trajectory$probability_LTx_BSC[i]) *         # Does not transition to lung transplant
    (1 - df_survivaldata$p_cycle_mortality_BSC[i])           # Survives this cycle
  
  # Transition probabilities for BSC.arm.LTx (transition to lung transplant in BSC arm)
  df_FEV1trajectory$BSC.arm.LTx[i] <- df_FEV1trajectory$BSC.arm[i - 1] *
    df_FEV1trajectory$probability_LTx_BSC[i] *               # Transitions to lung transplant
    (1 - df_survivaldata$p_cycle_mortality_BSC[i]) +         # Survives this cycle
    df_FEV1trajectory$BSC.arm.LTx[i - 1] *
    (1 - df_survivaldata$p_cycle_mortality_LTx[i])           # Survives post lung transplant
  
  # Transition probabilities for BSC.arm.Dead (death probabilities)
  df_FEV1trajectory$BSC.arm.Dead[i] <- df_FEV1trajectory$BSC.arm[i - 1] *
    df_survivaldata$p_cycle_mortality_BSC[i] +               # Dies in BSC
    df_FEV1trajectory$BSC.arm.LTx[i - 1] *
    df_survivaldata$p_cycle_mortality_LTx[i] +               # Dies post lung transplant
    df_FEV1trajectory$BSC.arm.Dead[i - 1]                    # Accumulated deaths
  
}

# Calculate the total for the Belumosudil.arm states across all categories
df_FEV1trajectory$Belumosudil.arm.Total <- round(rowSums(
  cbind(
    df_FEV1trajectory$Belumosudil.arm.1L,
    df_FEV1trajectory$Belumosudil.arm.2L.BSC,
    df_FEV1trajectory$Belumosudil.arm.LTx,
    df_FEV1trajectory$Belumosudil.arm.Dead
  )
))

# Calculate the total for the BSC.arm states across all categories
df_FEV1trajectory$BSC.arm.Total <- round(rowSums(
  cbind(
    df_FEV1trajectory$BSC.arm,
    df_FEV1trajectory$BSC.arm.LTx,
    df_FEV1trajectory$BSC.arm.Dead
  )
))

##############################################################
##############################################################
##############################################################
disc_rank_list <- lapply(2:nrow(df_FEV1trajectory), function(i) rep(NA, nrow(df_FEV1trajectory)))

names(disc_rank_list) <- paste0("disc_rank.", 2:nrow(df_FEV1trajectory))


for (i in 1:(nrow(df_FEV1trajectory)-1)) {
  
  disc_rank_list[[i]][1:((i+1)-1)]  <- df_FEV1trajectory$FEV1.belumosudil[1:((i+1)-1)]
  
  disc_rank_list[[i]] [(i+1):nrow(df_FEV1trajectory)] <- df_FEV1trajectory$FEV1.belumosudil[(i+1)-1] - n_declineFEV1.subsequent*c(1:( nrow(df_FEV1trajectory)- i))
  
  disc_rank_list[[i]] [which(disc_rank_list[[i]]<0)] <- 0
  
} 

df_disc_rank_list <- as.data.frame(disc_rank_list) %>% mutate(Cycle = df_FEV1trajectory$`df_survivaldata$Cycle`)



df_matrix <- as.matrix(df_disc_rank_list[, -which(names(df_disc_rank_list) == "Cycle")]) # Supprime Cycle

cycle_index <- df_disc_rank_list$Cycle

FEV1_disc <- rep(NA, nrow(df_FEV1trajectory))

FEV1_disc[2:nrow(df_FEV1trajectory)] <- sapply(2:nrow(df_FEV1trajectory), function(i) {
  data_subset <- df_matrix[cycle_index == (i - 1), 1:(i - 1), drop = FALSE]
  if (nrow(data_subset) > 0) {
    mean(data_subset)
  } else {
    NA
  }
})

FEV1_disc[1] <- df_FEV1trajectory$FEV1.belumosudil[1]
FEV1.disc.change <- calculate_FEV1_changes(FEV1_disc, n_baselineFEV1.clad0)
FEV1.disc.CLAD.stage <- calculate_CLAD_stages(FEV1.disc.change)

df_FEV1trajectory$FEV1.disc.CLAD.stage <- FEV1.disc.CLAD.stage

##############################################################
##############################################################
##############################################################


# -----------------------------------------------------
# Function to Calculate Life Years (LYs) for a Given Stage or LTx
# -----------------------------------------------------
calculate_LYs <- function(data, treatment_cols, stage_col = NULL, stage_value = NULL) {
  if (!is.null(stage_value)) {
    # Si stage_col est une chaîne unique, répéter cette chaîne pour chaque colonne de traitement
    if (length(stage_col) == 1) {
      stage_col <- rep(stage_col, length(treatment_cols))
    }
    
    # Vérifier que stage_col a la même longueur que treatment_cols
    if (length(stage_col) != length(treatment_cols)) {
      stop("stage_col must be either a single column name or a vector of the same length as treatment_cols.")
    }
    
    # Convertir les colonnes de stage en caractères
    for (col in stage_col) {
      data[[col]] <- as.character(data[[col]])
    }
    
    # Initialiser une matrice pour stocker les valeurs filtrées
    filtered_data <- matrix(0, nrow = nrow(data), ncol = length(treatment_cols))
    colnames(filtered_data) <- treatment_cols
    
    # Filtrer les données pour chaque colonne de traitement
    for (i in seq_along(treatment_cols)) {
      current_stage_col <- stage_col[i]
      current_treatment_col <- treatment_cols[i]
      
      # Vérifier si stage_value existe dans la colonne de stage
      if (!stage_value %in% unique(data[[current_stage_col]])) {
        stop(paste("Stage value", stage_value, "not found in", current_stage_col))
      }
      
      # Ajouter les données correspondantes à la matrice
      filtered_data[, i] <- ifelse(data[[current_stage_col]] == stage_value, 
                                   data[[current_treatment_col]], 
                                   0)
    }
    
    # Calculer la somme par ligne et diviser par 12
    summed_LYs <- rowSums(filtered_data) / 12
  } else {
    # Si stage_value n'est pas fourni, somme des colonnes de traitement pour toutes les lignes
    summed_LYs <- apply(data[treatment_cols], 1, sum) / 12
  }
  
  return(summed_LYs)
}

# -----------------------------------------------------
# LYs Calculation for Belumosudil
# -----------------------------------------------------
LYs_Belumosudil_clad1 <- calculate_LYs(df_FEV1trajectory, 
                                       c("Belumosudil.arm.1L", "Belumosudil.arm.2L.BSC"), 
                                       c("CLAD.stage.belumosudil", "CLAD.stage.BSC"),
                                       1)
LYs_Belumosudil_clad2 <- calculate_LYs(df_FEV1trajectory, 
                                       c("Belumosudil.arm.1L", "Belumosudil.arm.2L.BSC"), 
                                       c("CLAD.stage.belumosudil", "CLAD.stage.BSC"),
                                       2)
LYs_Belumosudil_clad3 <- calculate_LYs(df_FEV1trajectory, 
                                       c("Belumosudil.arm.1L", "Belumosudil.arm.2L.BSC"), 
                                       c("CLAD.stage.belumosudil", "CLAD.stage.BSC"),
                                       3)
LYs_Belumosudil_clad4 <- calculate_LYs(df_FEV1trajectory, 
                                       c("Belumosudil.arm.1L", "Belumosudil.arm.2L.BSC"), 
                                       c("CLAD.stage.belumosudil", "CLAD.stage.BSC"),
                                       4)
LYs_Belumosudil_LTx <- calculate_LYs(df_FEV1trajectory, 
                                     c("Belumosudil.arm.LTx"))


# -----------------------------------------------------
# LYs Calculation for BSC
# -----------------------------------------------------
LYs_BSC_clad1 <- calculate_LYs(df_FEV1trajectory, 
                               c("BSC.arm"), 
                               "CLAD.stage.BSC", 1)
LYs_BSC_clad2 <- calculate_LYs(df_FEV1trajectory, 
                               c("BSC.arm"), 
                               "CLAD.stage.BSC", 2)
LYs_BSC_clad3 <- calculate_LYs(df_FEV1trajectory, 
                               c("BSC.arm"), 
                               "CLAD.stage.BSC", 3)
LYs_BSC_clad4 <- calculate_LYs(df_FEV1trajectory, 
                               c("BSC.arm"), 
                               "CLAD.stage.BSC", 4)
LYs_BSC_LTx <- calculate_LYs(df_FEV1trajectory, 
                             c("BSC.arm.LTx"))





# -----------------------------------------------------
# Utility adjustment
# -----------------------------------------------------

general_pop_utility <- read_excel("~/general_pop_utility.xlsx")

general_pop_utility <- general_pop_utility %>% 
  mutate(
    General = female_percentage*Females + (1 - female_percentage)*Males
  )

adjustment_index <- rep(NA, nrow(general_pop_utility))

adjustment_index <- general_pop_utility$General/general_pop_utility$General[mean_age+1]

general_pop_utility <- general_pop_utility %>% 
  mutate(
    Adjustment.index = adjustment_index
  )

age.adjustment.utility.multiplier <- rep(NA, nrow(df_survivaldata))

age.adjustment.utility.multiplier <- general_pop_utility$Adjustment.index[
  match(floor(df_survivaldata$Age), general_pop_utility$Age)
]

if (include.utility.adjustment=="Yes") {
  age.adjustment.utility.multiplier <- age.adjustment.utility.multiplier
}
if (include.utility.adjustment=="No") {
  age.adjustment.utility.multiplier <- 1
}
df_survivaldata <- df_survivaldata %>% 
  mutate(
    Age.adjustment.utility.multiplier = age.adjustment.utility.multiplier
  )
  
# -----------------------------------------------------
# Utility Calculation Functions
# -----------------------------------------------------
calculate_utility_BOS <- function(SGRQ, percentage_male) {
  # Calculate BOS utility based on SGRQ and percentage of males
  0.9617 - 0.0013 * SGRQ - 0.0001 * SGRQ ^ 2 + 0.0231 * percentage_male
}

calculate_utility_RAS <- function(SGRQ) {
  # Calculate RAS utility based on SGRQ
  1.3246 - 0.01276 * SGRQ
}

# -----------------------------------------------------
# Utility Calculation for Each CLAD Stage
# -----------------------------------------------------
calculate_utility_cladstage <- function(SGRQ_values,
                                        percentage_male,
                                        p_BOS,
                                        p_RAS) {
  # Calculate utilities for each CLAD stage
  BOS_utilities <- calculate_utility_BOS(SGRQ = SGRQ_values, percentage_male = percentage_male)
  RAS_utilities <- calculate_utility_RAS(SGRQ = SGRQ_values)
  
  # Combine BOS and RAS utilities weighted by probabilities
  utilities <- p_BOS * BOS_utilities + p_RAS * RAS_utilities
  
  # Assign names for clarity
  names(utilities) <- c("clad0", "clad1", "clad2", "clad3", "clad4", "LTx")
  return(utilities)
}

# -----------------------------------------------------
# Inputs and Calculations
# -----------------------------------------------------
# Define SGRQ values for each stage
SGRQ_values <- c(SGRQ_clad0,
                 SGRQ_clad1,
                 SGRQ_clad2,
                 SGRQ_clad3,
                 SGRQ_clad4,
                 SGRQ_LTx)

# Calculate utilities for each stage
utility_cladstage <- calculate_utility_cladstage(
  SGRQ_values = SGRQ_values,
  percentage_male = (1 - female_percentage),
  p_BOS = p_incidence_BOS,
  p_RAS = p_incidence_RAS
)

# Extract individual utilities
utility_clad0 <- utility_cladstage["clad0"]
utility_clad1 <- utility_cladstage["clad1"]
utility_clad2 <- utility_cladstage["clad2"]
utility_clad3 <- utility_cladstage["clad3"]
utility_clad4 <- utility_cladstage["clad4"]
utility_LTx <- utility_cladstage["LTx"]



# Calculate QALYs for Belumosudil treatment at each stage
QALYs_Belumosudil_clad1 <- LYs_Belumosudil_clad1 * utility_clad1 * df_survivaldata$Age.adjustment.utility.multiplier # Multiply LYs at clad1 stage by the corresponding utility
QALYs_Belumosudil_clad2 <- LYs_Belumosudil_clad2 * utility_clad2 * df_survivaldata$Age.adjustment.utility.multiplier # Multiply LYs at clad2 stage by the corresponding utility
QALYs_Belumosudil_clad3 <- LYs_Belumosudil_clad3 * utility_clad3 * df_survivaldata$Age.adjustment.utility.multiplier # Multiply LYs at clad3 stage by the corresponding utility
QALYs_Belumosudil_clad4 <- LYs_Belumosudil_clad4 * utility_clad4 * df_survivaldata$Age.adjustment.utility.multiplier # Multiply LYs at clad4 stage by the corresponding utility
QALYs_Belumosudil_LTx   <- LYs_Belumosudil_LTx * utility_LTx * df_survivaldata$Age.adjustment.utility.multiplier     # Multiply LYs at LTx stage by the corresponding utility

# Calculate QALYs for BSC treatment at each stage
QALYs_BSC_clad1 <- LYs_BSC_clad1 * utility_clad1 * df_survivaldata$Age.adjustment.utility.multiplier  # Multiply LYs at clad1 stage by the corresponding utility for BSC
QALYs_BSC_clad2 <- LYs_BSC_clad2 * utility_clad2 * df_survivaldata$Age.adjustment.utility.multiplier  # Multiply LYs at clad2 stage by the corresponding utility for BSC
QALYs_BSC_clad3 <- LYs_BSC_clad3 * utility_clad3 * df_survivaldata$Age.adjustment.utility.multiplier  # Multiply LYs at clad3 stage by the corresponding utility for BSC
QALYs_BSC_clad4 <- LYs_BSC_clad4 * utility_clad4 * df_survivaldata$Age.adjustment.utility.multiplier  # Multiply LYs at clad4 stage by the corresponding utility for BSC
QALYs_BSC_LTx   <- LYs_BSC_LTx * utility_LTx * df_survivaldata$Age.adjustment.utility.multiplier      # Multiply LYs at LTx stage by the corresponding utility for BSC



p_AE_belumosudil <- c(
  p_AE_pneumonia_belumosudil,
  p_AE_hypertension_belumosudil,
  p_AE_anaemia_belumosudil,
  p_AE_thrombocytopenia_belumosudil,
  p_AE_hyperglycaemia_belumosudil,
  p_AE_GGT_increased_belumosudil,
  p_AE_diarrhoea_belumosudil,
  p_AE_AE8_belumosudil,
  p_AE_AE9_belumosudil,
  p_AE_AE10_belumosudil,
  p_AE_AE11_belumosudil
)

p_AE_BSC <- c(
  p_AE_pneumonia_BSC,
  p_AE_hypertension_BSC,
  p_AE_anaemia_BSC,
  p_AE_thrombocytopenia_BSC,
  p_AE_hyperglycaemia_BSC,
  p_AE_GGT_increased_BSC,
  p_AE_diarrhoea_BSC,
  p_AE_AE8_BSC,
  p_AE_AE9_BSC,
  p_AE_AE10_BSC,
  p_AE_AE11_BSC
)

disutility <- c(
  disutility_pneumonia,
  disutility_hypertension,
  disutility_anaemia,
  disutility_thrombocytopenia,
  disutility_hyperglycaemia,
  disutility_GGT_increased,
  disutility_diarrhoea,
  disutility_AE8,
  disutility_AE9,
  disutility_AE10,
  disutility_AE11
)

duration_days <- c(
  duration_days_pneumonia,
  duration_days_hypertension,
  duration_days_anaemia,
  duration_days_thrombocytopenia,
  duration_days_hyperglycaemia,
  duration_days_GGT_increased,
  duration_days_diarrhoea,
  duration_days_AE8,
  duration_days_AE9,
  duration_days_AE10,
  duration_days_AE11
)

disutility_calculation <- function(p_AE, disutility, duration) {
  # Check that all three vectors have the same length
  if (length(p_AE) != length(disutility) || length(p_AE) != length(duration)) {
    stop("All  vectors must have the same length.")
  }
  
  # Calculate the sum-product
  result <- sum(p_AE * disutility * duration/df_survivaldata$Days[2])
  return(result)
}

total_disutility_belumosudil <- disutility_calculation(p_AE_belumosudil, disutility, duration_days)
total_disutility_BSC <- disutility_calculation(p_AE_BSC, disutility, duration_days)

if (include_AE_disutility=="Include") {
  

AE_disutility_belumosudil <- c(total_disutility_belumosudil*df_FEV1trajectory$Belumosudil.arm.1L[1],
                               total_disutility_BSC*df_FEV1trajectory$Belumosudil.arm.newly.2L.BSC[2:nrow(df_FEV1trajectory)])

AE_disutility_BSC <- c(total_disutility_BSC*df_FEV1trajectory$Belumosudil.arm.1L[1],
                       0*df_FEV1trajectory$Belumosudil.arm.newly.2L.BSC[2:nrow(df_FEV1trajectory)])

}
if (include_AE_disutility=="Exclude") {
  
  
  AE_disutility_belumosudil <-0
  
  AE_disutility_BSC <- 0
  
}

df_outcomes_payoffs <- data.frame(
  
  LYs.Belumosudil.undiscounted = rowSums(cbind(LYs_Belumosudil_clad1, LYs_Belumosudil_clad2, LYs_Belumosudil_clad3,
                                               LYs_Belumosudil_clad4 , LYs_Belumosudil_LTx)),
  QALYs.Belumosudil.undiscounted = rowSums(cbind(QALYs_Belumosudil_clad1, QALYs_Belumosudil_clad2, QALYs_Belumosudil_clad3,
                                                 QALYs_Belumosudil_clad4,  QALYs_Belumosudil_LTx, AE_disutility_belumosudil)),
  LYs.BSC.undiscounted = rowSums(cbind(LYs_BSC_clad1, LYs_BSC_clad2, LYs_BSC_clad3,
                                       LYs_BSC_clad4, LYs_BSC_LTx)),
  QALYs.BSC.undiscounted = rowSums(cbind(QALYs_BSC_clad1 , QALYs_BSC_clad2 , QALYs_BSC_clad3,
                                         QALYs_BSC_clad4 , QALYs_BSC_LTx, AE_disutility_BSC))
  
)















