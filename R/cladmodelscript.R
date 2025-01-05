library(dplyr)
library(readxl)
library(heemod)


# ========================================================
# General Settings
# ========================================================
time_horizon <- 50            # Time horizon for the analysis (in years)
dr_cost <- 0.035              # Discount rate for costs
dr_outcomes <- 0.035          # Discount rate for health outcomes
wtp_threshold <- 30000        # Willingness-to-pay threshold (in monetary units)

# ========================================================
# Patient Population Characteristics
# ========================================================
mean_age <- 56                # Average age of the patient population
female_percentage <- 0.43     # Proportion of female patients
mean_weight <- 82             # Average weight of the patient population (in kg)

# ========================================================
# Disease Incidence Probabilities
# ========================================================
p_incidence_BOS <- 0.875      # Probability of BOS phenotypes
p_incidence_RAS <- 0.125      # Probability of RAS phenotypes

# ========================================================
# Baseline Characteristics (FEV1)
# ========================================================
n_baseline.clad <- 1          # Baseline Clad stage is set to 1
n_baselineFEV1_BOS <- 2000    # Baseline FEV1 value for BOS patients (in mL)
n_baselineFEV1_RAS <- 1520    # Baseline FEV1 value for RAS patients (in mL)

# ========================================================
# Annual FEV1 Decline Rates
# ========================================================
# Year 1 FEV1 decline rates
n_declineFEV1.year1_BOS <- 25.556  # Decline rate for BOS patients (mL/year)
n_declineFEV1.year1_RAS <- 21.944  # Decline rate for RAS patients (mL/year)

# Subsequent years FEV1 decline rates
n_declineFEV1.subsequent_BOS <- 25.556  # Subsequent decline rate for BOS patients (mL/year)
n_declineFEV1.subsequent_RAS <- 21.944  # Subsequent decline rate for RAS patients (mL/year)

# Relative risk reduction of FEV1 decline with Belumosudil
rr_decline_belumosudil_BOS <- 0.27  # BOS patients
rr_decline_belumosudil_RAS <- 0.27  # RAS patients

# ========================================================
# Survival Analysis Parameters
# ========================================================
survival_function <- "Log-normal"  # Type of survival distribution used
hr_belumosudil <- 0.73             # Hazard ratio for Belumosudil
hr_clad1 <- 0.8                    # Hazard ratio for Clad1
hr_clad2 <- 1                      # Hazard ratio for Clad2
hr_clad3 <- 1.5                    # Hazard ratio for Clad3
hr_clad4 <- 3                      # Hazard ratio for Clad4

# ========================================================
# Lung Transplantation (LTx) Probabilities
# ========================================================
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

# ========================================================
# Stop Rule Probabilities (for different Clad levels)
# ========================================================
p_stoprule_clad1 <- 0
p_stoprule_clad2 <- 0
p_stoprule_clad3 <- 0
p_stoprule_clad4 <- 1          # Only applied for Clad4 level

# ========================================================
# Discontinuation Rate for Belumosudil
# ========================================================
p_disc_belumosudil <- 0.0119   # Probability of discontinuing Belumosudil


# ========================================================
# Adverse Event (AE)
# ========================================================

# -----------------------------------------------------
# Adverse Event (AE) Probabilities
# -----------------------------------------------------

# Percentage of AEs managed in outpatient setting
p_AE_managed.outpatient <- 1  # Percentage of adverse events (AEs) managed in an outpatient setting. 
# Value of 1 indicates all AEs are managed in outpatient.

# Probabilities of AEs for Belumosudil
p_AE_pneumonia_belumosudil <- 0.003576921  # Probability of pneumonia AE for Belumosudil
p_AE_hypertension_belumosudil <- 0.003576921  # Probability of hypertension AE for Belumosudil
p_AE_anaemia_belumosudil <- 0.002039584  # Probability of anaemia AE for Belumosudil
p_AE_thrombocytopenia_belumosudil <- 0.001540479  # Probability of thrombocytopenia AE for Belumosudil
p_AE_hyperglycaemia_belumosudil <- 0.002579999  # Probability of hyperglycaemia AE for Belumosudil
p_AE_GGT_increased_belumosudil <- 0.002579999  # Probability of GGT increased AE for Belumosudil
p_AE_diarrhoea_belumosudil <- 0.000  # Probability of diarrhoea AE for Belumosudil (no occurrence)
p_AE_AE8_belumosudil <- 0.000  # Placeholder for additional AE (AE8) probability for Belumosudil
p_AE_AE9_belumosudil <- 0.000  # Placeholder for additional AE (AE9) probability for Belumosudil
p_AE_AE10_belumosudil <- 0.000  # Placeholder for additional AE (AE10) probability for Belumosudil
p_AE_AE11_belumosudil <- 0.000  # Placeholder for additional AE (AE11) probability for Belumosudil

# Probabilities of AEs for Best Supportive Care (BSC)
p_AE_pneumonia_BSC <- 0.016995273  # Probability of pneumonia AE for Best Supportive Care (BSC)
p_AE_hypertension_BSC <- 0.012491647  # Probability of hypertension AE for BSC
p_AE_anaemia_BSC <- 0.013619484  # Probability of anaemia AE for BSC
p_AE_thrombocytopenia_BSC <- 0.018117967  # Probability of thrombocytopenia AE for BSC
p_AE_hyperglycaemia_BSC <- 0.0034224  # Probability of hyperglycaemia AE for BSC
p_AE_GGT_increased_BSC <- 0.0034224  # Probability of GGT increased AE for BSC
p_AE_diarrhoea_BSC <- 0.002282904  # Probability of diarrhoea AE for BSC
p_AE_AE8_BSC <- 0.000  # Placeholder for additional AE (AE8) probability for BSC
p_AE_AE9_BSC <- 0.000  # Placeholder for additional AE (AE9) probability for BSC
p_AE_AE10_BSC <- 0.000  # Placeholder for additional AE (AE10) probability for BSC
p_AE_AE11_BSC <- 0.000  # Placeholder for additional AE (AE11) probability for BSC

# -----------------------------------------------------
# Unit Costs for Outpatient Management of AEs
# -----------------------------------------------------

# Costs for managing AEs in outpatient setting for Belumosudil
c_AE_pneumonia_outpatient <- 371.768  # Cost for managing pneumonia in outpatient setting for Belumosudil
c_AE_hypertension_outpatient <- 447.730  # Cost for managing hypertension in outpatient setting for Belumosudil
c_AE_anaemia_outpatient <- 394.642  # Cost for managing anaemia in outpatient setting for Belumosudil
c_AE_thrombocytopenia_outpatient <- 442.712  # Cost for managing thrombocytopenia in outpatient setting for Belumosudil
c_AE_hyperglycaemia_outpatient <- 485.777  # Cost for managing hyperglycaemia in outpatient setting for Belumosudil
c_AE_GGT_increased_outpatient <- 485.777  # Cost for managing increased GGT levels in outpatient setting for Belumosudil
c_AE_diarrhoea_outpatient <- 388.046  # Cost for managing diarrhoea in outpatient setting for Belumosudil
c_AE_AE8_outpatient <- 0  # Placeholder for AE8 outpatient management cost
c_AE_AE9_outpatient <- 0  # Placeholder for AE9 outpatient management cost
c_AE_AE10_outpatient <- 0  # Placeholder for AE10 outpatient management cost
c_AE_AE11_outpatient <- 0  # Placeholder for AE11 outpatient management cost

# -----------------------------------------------------
# Unit Costs for Inpatient Management of AEs
# -----------------------------------------------------

# Costs for managing AEs in inpatient setting for Belumosudil
c_AE_pneumonia_inpatient <- 3344.581  # Cost for managing pneumonia in inpatient setting for Belumosudil
c_AE_hypertension_inpatient <- 1478.830  # Cost for managing hypertension in inpatient setting for Belumosudil
c_AE_anaemia_inpatient <- 1371.608  # Cost for managing anaemia in inpatient setting for Belumosudil
c_AE_thrombocytopenia_inpatient <- 1972.554  # Cost for managing thrombocytopenia in inpatient setting for Belumosudil
c_AE_hyperglycaemia_inpatient <- 767.985  # Cost for managing hyperglycaemia in inpatient setting for Belumosudil
c_AE_GGT_increased_inpatient <- 767.985  # Cost for managing increased GGT levels in inpatient setting for Belumosudil
c_AE_diarrhoea_inpatient <- 3484.009  # Cost for managing diarrhoea in inpatient setting for Belumosudil
c_AE_AE8_inpatient <- 0  # Placeholder for AE8 inpatient management cost
c_AE_AE9_inpatient <- 0  # Placeholder for AE9 inpatient management cost
c_AE_AE10_inpatient <- 0  # Placeholder for AE10 inpatient management cost
c_AE_AE11_inpatient <- 0  # Placeholder for AE11 inpatient management cost

# ========================================================
# Utility
# ========================================================

# Health Utility Method
health_utility_method <- "SGRQ based (CLAD)"  # Health utility method used, based on SGRQ for CLAD stages.
# Options include: CLAD (GOLD) stage-based COPD as proxy, 
# and FEV1 based (COPD as proxy).

# Health State Utility Source
health_state_utility_source <- "Esquinas et al.(2020)"  # Source of health state utility data, e.g., Esquinas et al. (2020),
# Pickard et al. (2011) for UK and US indices.

# Utility Adjustment
include.utility.adjustment <- "Yes"  # Indicates whether to include utility adjustment.
include_AE_disutility <- "Include"  # Indicates whether to include disutility related to adverse events (AEs).

# SGRQ Scores by CLAD Stages
SGRQ_clad0 <- 38  # SGRQ score for CLAD stage 0
SGRQ_clad1 <- 38  # SGRQ score for CLAD stage 1
SGRQ_clad2 <- 38  # SGRQ score for CLAD stage 2
SGRQ_clad3 <- 63  # SGRQ score for CLAD stage 3
SGRQ_clad4 <- 63  # SGRQ score for CLAD stage 4
SGRQ_LTx <- 54.67  # SGRQ score for Lung Transplant (LTx)

# FEV1 Baseline Utility and Disutility
FEV1_baseline_utility <- 0.739  # Baseline utility for FEV1 in the model
disutility_by_percent_reduction_FEV1 <- -0.0023  # Disutility for each percentage reduction in FEV1

# Utility by CLAD Stage based on Esquinas et al. (2020)
utility_clad0_stage.based_Esquinas.source <- 0.70  # Utility for CLAD stage 0
utility_clad1_stage.based_Esquinas.source <- 0.70  # Utility for CLAD stage 1
utility_clad2_stage.based_Esquinas.source <- 0.70  # Utility for CLAD stage 2
utility_clad3_stage.based_Esquinas.source <- 0.66  # Utility for CLAD stage 3
utility_clad4_stage.based_Esquinas.source <- 0.60  # Utility for CLAD stage 4
utility_LTx_stage.based_Esquinas.source <- 0.65333  # Utility for Lung Transplant (LTx)

# Utility by CLAD Stage based on Pickard et al. (UK index)
utility_clad0_stage.based_Pickard.UK.source <- 0.73  # Utility for CLAD stage 0 (UK)
utility_clad1_stage.based_Pickard.UK.source <- 0.59  # Utility for CLAD stage 1 (UK)
utility_clad2_stage.based_Pickard.UK.source <- 0.59  # Utility for CLAD stage 2 (UK)
utility_clad3_stage.based_Pickard.UK.source <- 0.63  # Utility for CLAD stage 3 (UK)
utility_clad4_stage.based_Pickard.UK.source <- 0.63  # Utility for CLAD stage 4 (UK)
utility_LTx_stage.based_Pickard.UK.source <- 0.61667  # Utility for Lung Transplant (LTx) (UK)

# Utility by CLAD Stage based on Pickard et al. (US index)
utility_clad0_stage.based_Pickard.US.source <- 0.80  # Utility for CLAD stage 0 (US)
utility_clad1_stage.based_Pickard.US.source <- 0.70  # Utility for CLAD stage 1 (US)
utility_clad2_stage.based_Pickard.US.source <- 0.70  # Utility for CLAD stage 2 (US)
utility_clad3_stage.based_Pickard.US.source <- 0.72  # Utility for CLAD stage 3 (US)
utility_clad4_stage.based_Pickard.US.source <- 0.72  # Utility for CLAD stage 4 (US)
utility_LTx_stage.based_Pickard.US.source <- 0.71333  # Utility for Lung Transplant (LTx) (US)

# Disutility due to Adverse Events (AEs)
disutility_pneumonia <- -0.195  # Disutility for pneumonia
disutility_hypertension <- -0.020  # Disutility for hypertension
disutility_anaemia <- -0.900  # Disutility for anaemia
disutility_thrombocytopenia <- -0.110  # Disutility for thrombocytopenia
disutility_hyperglycaemia <- 0  # Disutility for hyperglycaemia
disutility_GGT_increased <- 0  # Disutility for increased GGT levels
disutility_diarrhoea <- -0.176  # Disutility for diarrhoea
disutility_AE8 <- 0  # Placeholder for additional AE disutility
disutility_AE9 <- 0  # Placeholder for additional AE disutility
disutility_AE10 <- 0  # Placeholder for additional AE disutility
disutility_AE11 <- 0  # Placeholder for additional AE disutility

# Duration of Adverse Events (AEs) in Days
duration_days_pneumonia <- 14.7  # Duration for pneumonia
duration_days_hypertension <- 21.0  # Duration for hypertension
duration_days_anaemia <- 23.2  # Duration for anaemia
duration_days_thrombocytopenia <- 23.2  # Duration for thrombocytopenia
duration_days_hyperglycaemia <- 0  # Duration for hyperglycaemia
duration_days_GGT_increased <- 0  # Duration for increased GGT levels
duration_days_diarrhoea <- 7  # Duration for diarrhoea
duration_days_AE8 <- 0  # Placeholder for duration of AE8
duration_days_AE9 <- 0  # Placeholder for duration of AE9
duration_days_AE10 <- 0  # Placeholder for duration of AE10
duration_days_AE11 <- 0  # Placeholder for duration of AE11

# ========================================================
# PPI
# ========================================================

percentage_receiving_ppi <- 0.7  

# ========================================================
# Drug Prices
# ========================================================

# --------------------------------------------------------
# Belumosudil
# --------------------------------------------------------
generic_name_belumosudil <- "Belumosudil"  # Generic name of the drug
brand_name_belumosudil <- "REZUROCK®"  # Brand name of the drug
dose_form_belumosudil <- "Oral"  # Dosage form (e.g., oral, IV, etc.)
dose_mg_belumosudil <- 200  # Drug dose in mg
dosing_regimen_belumosudil <- "200 mg once daily"  # Recommended dosing regimen
strength_per_unit_belumosudil <- 200  # Strength per unit (mg per tablet or capsule)
pack_size_belumosudil <- 30  # Number of units in a pack
pack_price_belumosudil <- 6708  # Price per pack in £
pas_discount_belumosudil <- 0  # PAS (Patient Access Scheme) discount in %
absolute_reduction_belumosudil <- 0  # Absolute price reduction in £
discount_belumosudil <- 0  # Additional discount in %

# --------------------------------------------------------
# Azithromycin
# --------------------------------------------------------
generic_name_azithromycin <- "Azithromycin"  # Generic name of the drug
brand_name_azithromycin <- "NR"  # Brand name (NR indicates not reported)
dose_form_azithromycin <- "Oral"  # Dosage form (e.g., oral)
dose_mg_azithromycin <- 250  # Drug dose in mg
dosing_regimen_azithromycin <- "250 mg three times a week"  # Recommended dosing regimen
strength_per_unit_azithromycin <- 250  # Strength per unit (mg per tablet)
pack_size_azithromycin <- 4  # Number of units in a pack
pack_price_azithromycin <- 0.94  # Price per pack in £
pas_discount_azithromycin <- 0  # PAS discount in %
absolute_reduction_azithromycin <- 0  # Absolute price reduction in £
discount_azithromycin <- 0  # Additional discount in %

# --------------------------------------------------------
# Omeprazole (PPI)
# --------------------------------------------------------
generic_name_omeprazole <- "Omeprazole (PPI)"  # Generic name of the drug
brand_name_omeprazole <- "NR"  # Brand name (NR indicates not reported)
dose_form_omeprazole <- "Oral"  # Dosage form (e.g., oral)
dose_mg_omeprazole <- 20  # Drug dose in mg
dosing_regimen_omeprazole <- "20 mg once daily"  # Recommended dosing regimen
strength_per_unit_omeprazole <- 20  # Strength per unit (mg per tablet)
pack_size_omeprazole <- 28  # Number of units in a pack
pack_price_omeprazole <- 6.16  # Price per pack in £
pas_discount_omeprazole <- 0  # PAS discount in %
absolute_reduction_omeprazole <- 0  # Absolute price reduction in £
discount_omeprazole <- 0  # Additional discount in %


# ========================================================
# Number of Doses per Monthly Cycle
# ========================================================

# --------------------------------------------------------
# Belumosudil
# --------------------------------------------------------
number_doses_belumosudil_first_cycle <- 51.56666667   # Doses during the first cycle
number_doses_belumosudil_cycle_2 <- 51.56666667      # Doses during the second cycle
number_doses_belumosudil_subsequent_cycles <- 51.56666667  # Doses during subsequent cycles

# --------------------------------------------------------
# Azithromycin
# --------------------------------------------------------
number_doses_azithromycin_first_cycle <- 13  # Doses during the first cycle
number_doses_azithromycin_cycle_2 <- 13      # Doses during the second cycle
number_doses_azithromycin_subsequent_cycles <- 13  # Doses during subsequent cycles

# --------------------------------------------------------
# Omeprazole (PPI)
# --------------------------------------------------------
number_doses_omeprazole_first_cycle <- 30.33333333    # Doses during the first cycle
number_doses_omeprazole_cycle_2 <- 30.33333333        # Doses during the second cycle
number_doses_omeprazole_subsequent_cycles <- 30.33333333  # Doses during subsequent cycles


# ========================================================
# Disease management drug prices
# ========================================================

# --------------------------------------------------------
# Azathioprine
# --------------------------------------------------------
generic_name_azathioprine <- "Azathioprine"  # Generic name of the drug
brand_name_azathioprine <- "NR"             # Brand name (not reported here)
dose_form_azathioprine <- "Oral"            # Form of administration
drug_dose_mg_azathioprine <- 143.0625       # Dose in mg
dosing_regimen_azathioprine <- "1-2.5 mg/kg daily by mouth"  # Recommended regimen
strength_per_unit_azathioprine <- 100       # Strength per unit (mg)
pack_size_azathioprine <- 100               # Number of units in a pack
pack_price_azathioprine <- 43.96               # Pack price (£)
discount_azathioprine <- 0                  # Discount percentage (%)

# --------------------------------------------------------
# MMF
# --------------------------------------------------------
generic_name_mmf <- "MMF"                   # Generic name of the drug
brand_name_mmf <- "NR"                      # Brand name (not reported here)
dose_form_mmf <- "Oral"                     # Form of administration
drug_dose_mg_mmf <- 1000                    # Dose in mg
dosing_regimen_mmf <- "1,000 mg twice daily"  # Recommended regimen
strength_per_unit_mmf <- 500                # Strength per unit (mg)
pack_size_mmf <- 50                         # Number of units in a pack
pack_price_mmf <- 6.19                      # Pack price (£)
discount_mmf <- 0                           # Discount percentage (%)

# --------------------------------------------------------
# ECP
# --------------------------------------------------------
generic_name_ecp <- "ECP"                   # Generic name of the treatment
brand_name_ecp <- "NR"                      # Brand name (not reported here)
dose_form_ecp <- "IV"                       # Form of administration
drug_dose_mg_ecp <- 3.2                     # Sessions per 28-day cycle
dosing_regimen_ecp <- "3.2 sessions per 28-day cycle"  # Recommended regimen
strength_per_unit_ecp <- 1                  # Strength per session (1 session)
pack_size_ecp <- 1                          # Number of units in a pack
pack_price_ecp <- 1585                      # Pack price (£)
discount_ecp <- 0                           # Discount percentage (%)

# --------------------------------------------------------
# Prednisone
# --------------------------------------------------------
generic_name_prednisone <- "Prednisone"     # Generic name of the drug
brand_name_prednisone <- "NR"               # Brand name (not reported here)
dose_form_prednisone <- "Oral"              # Form of administration
drug_dose_mg_prednisone <- 81.75            # Dose in mg
dosing_regimen_prednisone <- "1 mg/kg every other day"  # Recommended regimen
strength_per_unit_prednisone <- 25          # Strength per unit (mg)
pack_size_prednisone <- 56                  # Number of units in a pack
pack_price_prednisone <- 42.44                 # Pack price (£)
discount_prednisone <- 0                    # Discount percentage (%)

# --------------------------------------------------------
# Cyclosporine
# --------------------------------------------------------
generic_name_cyclosporine <- "Cyclosporine"  # Generic name of the drug
brand_name_cyclosporine <- "NR"              # Brand name (not reported here)
dose_form_cyclosporine <- "Oral"             # Form of administration
drug_dose_mg_cyclosporine <- 327             # Dose in mg
dosing_regimen_cyclosporine <- "2-6 mg/kg daily by mouth as a maintenance regimen"  # Recommended regimen
strength_per_unit_cyclosporine <- 100        # Strength per unit (mg)
pack_size_cyclosporine <- 30                 # Number of units in a pack
pack_price_cyclosporine <- 41.59                # Pack price (£)
discount_cyclosporine <- 0                   # Discount percentage (%)

# --------------------------------------------------------
# Tacrolimus
# --------------------------------------------------------
generic_name_tacrolimus <- "Tacrolimus"      # Generic name of the drug
brand_name_tacrolimus <- "NR"                # Brand name (not reported here)
dose_form_tacrolimus <- "Oral"               # Form of administration
drug_dose_mg_tacrolimus <- 1                 # Dose in mg
dosing_regimen_tacrolimus <- "1 mg twice daily"  # Recommended regimen
strength_per_unit_tacrolimus <- 1            # Strength per unit (mg)
pack_size_tacrolimus <- 30                   # Number of units in a pack
pack_price_tacrolimus <- 59.1                  # Pack price (£)
discount_tacrolimus <- 0                     # Discount percentage (%)


# ========================================================
# Number of Doses per Monthly Cycle
# ========================================================

# --------------------------------------------------------
# CLAD 0-2 Data
# --------------------------------------------------------

# Azathioprine
clad_0_2_azathioprine <- 6.6733  # Number of doses for CLAD 0-2

# MMF
clad_0_2_mmf <- 13.3467  # Number of doses for CLAD 0-2

# ECP
clad_0_2_ecp <- 0.0433  # Number of doses for CLAD 0-2

# Prednisone
clad_0_2_prednisone <- 6.825  # Number of doses for CLAD 0-2

# Cyclosporine
clad_0_2_cyclosporine <- 33.9733  # Number of doses for CLAD 0-2

# Tacrolimus
clad_0_2_tacrolimus <- 67.9467  # Number of doses for CLAD 0-2

# --------------------------------------------------------
# CLAD 3 Data
# --------------------------------------------------------

# Azathioprine
clad_3_azathioprine <- 7.8867  # Number of doses for CLAD 3

# MMF
clad_3_mmf <- 15.773  # Number of doses for CLAD 3

# ECP
clad_3_ecp <- 0.0325  # Number of doses for CLAD 3

# Prednisone
clad_3_prednisone <- 11.83  # Number of doses for CLAD 3

# Cyclosporine
clad_3_cyclosporine <- 37.0067  # Number of doses for CLAD 3

# Tacrolimus
clad_3_tacrolimus <- 74.0133  # Number of doses for CLAD 3

# --------------------------------------------------------
# CLAD 4 Data
# -------------------------------------------------------- 

# Azathioprine
clad_4_azathioprine <- 5.915  # Number of doses for CLAD 4

# MMF
clad_4_mmf <- 11.83  # Number of doses for CLAD 4

# ECP
clad_4_ecp <- 0.0867  # Number of doses for CLAD 4

# Prednisone
clad_4_prednisone <- 8.3417  # Number of doses for CLAD 4

# Cyclosporine
clad_4_cyclosporine <- 31.85  # Number of doses for CLAD 4

# Tacrolimus
clad_4_tacrolimus <- 63.7  # Number of doses for CLAD 4

# ========================================================
# Administration Costs
# ========================================================

unit_cost_admin_ECP <- 124.155
unit_cost_admin_oral <- 0


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

# Calculate the relative change in FEV1 for both treatments from baseline FEV1 (Clad1)
df_FEV1trajectory$Change.from.clad1.FEV1.belumosudil <- calculate_FEV1_changes(df_FEV1trajectory$FEV1.belumosudil, n_baselineFEV1)
df_FEV1trajectory$Change.from.clad1.FEV1.BSC <- calculate_FEV1_changes(df_FEV1trajectory$FEV1.BSC, n_baselineFEV1)

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
# Utility Mapping Calculation Functions
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
# Utility Calculation for Each CLAD Stage SGRQ
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
# Utility CLAD calculation
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
if (health_utility_method=="SGRQ based (CLAD)") {
  
  utility_clad0 <- utility_cladstage["clad0"]
  utility_clad1 <- utility_cladstage["clad1"]
  utility_clad2 <- utility_cladstage["clad2"]
  utility_clad3 <- utility_cladstage["clad3"]
  utility_clad4 <- utility_cladstage["clad4"]
  utility_LTx <- utility_cladstage["LTx"]
}

if (health_utility_method=="CLAD (GOLD) stage-based COPD as proxy") {
  
  if (health_state_utility_source=="Esquinas et al.(2020)") {
    
    utility_clad0 <- utility_clad0_stage.based_Esquinas.source
    utility_clad1 <- utility_clad1_stage.based_Esquinas.source
    utility_clad2 <- utility_clad2_stage.based_Esquinas.source
    utility_clad3 <- utility_clad3_stage.based_Esquinas.source
    utility_clad4 <- utility_clad4_stage.based_Esquinas.source
    utility_LTx <- utility_LTx_stage.based_Esquinas.source
  }
  if (health_state_utility_source=="Pickard et al.(2011) (UK index)") {
    
    utility_clad0 <- utility_clad0_stage.based_Pickard.UK.source
    utility_clad1 <- utility_clad1_stage.based_Pickard.UK.source
    utility_clad2 <- utility_clad2_stage.based_Pickard.UK.source
    utility_clad3 <- utility_clad3_stage.based_Pickard.UK.source
    utility_clad4 <- utility_clad4_stage.based_Pickard.UK.source
    utility_LTx <- utility_LTx_stage.based_Pickard.UK.source
  }
  if (health_state_utility_source=="Pickard et al.(2011) (US index)") {
    
    utility_clad0 <- utility_clad0_stage.based_Pickard.US.source
    utility_clad1 <- utility_clad1_stage.based_Pickard.US.source
    utility_clad2 <- utility_clad2_stage.based_Pickard.US.source
    utility_clad3 <- utility_clad3_stage.based_Pickard.US.source
    utility_clad4 <- utility_clad4_stage.based_Pickard.US.source
    utility_LTx <- utility_LTx_stage.based_Pickard.US.source
  }
  
 
}
# -----------------------------------------------------
# QALYs CLAD calculation
# -----------------------------------------------------

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

# -----------------------------------------------------
# QALYs FEV1 calculation
# -----------------------------------------------------

QALYs_FEV1.based_belumosudil <- rep(NA, nrow(df_FEV1trajectory))

QALYs_FEV1.based_belumosudil <- ( FEV1_baseline_utility + disutility_by_percent_reduction_FEV1 *
  (
    df_FEV1trajectory$Change.from.clad1.FEV1.belumosudil * 100 * df_FEV1trajectory$Belumosudil.arm.1L +
      (
        df_FEV1trajectory$Belumosudil.arm.2L.BSC + df_FEV1trajectory$Belumosudil.arm.LTx
      ) *
      df_FEV1trajectory$Change.from.clad1.FEV1.BSC * 100 
  ) ) *
  df_survivaldata$Age.adjustment.utility.multiplier *
  (rowSums(
    cbind(
      LYs_Belumosudil_clad1,
      LYs_Belumosudil_clad2,
      LYs_Belumosudil_clad3,
      LYs_Belumosudil_clad4 ,
      LYs_Belumosudil_LTx
    )
  ))

QALYs_FEV1.based_BSC <- rep(NA, nrow(df_FEV1trajectory))
QALYs_FEV1.based_BSC <- ( FEV1_baseline_utility + disutility_by_percent_reduction_FEV1 *
                            ( df_FEV1trajectory$Change.from.clad1.FEV1.BSC * 100 * df_FEV1trajectory$BSC.arm )) *
  df_survivaldata$Age.adjustment.utility.multiplier *
  (rowSums(
    cbind(
      LYs_BSC_clad1,
      LYs_BSC_clad2,
      LYs_BSC_clad3,
      LYs_BSC_clad4 ,
      LYs_BSC_LTx
    )
  ))

# -----------------------------------------------------
# Adverse Event disutility calculation
# -----------------------------------------------------

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


if (health_utility_method=="FEV1 based (COPD as proxy)") {
df_outcomes_payoffs <- data.frame(
  
  LYs.Belumosudil.undiscounted = rowSums(cbind(LYs_Belumosudil_clad1, LYs_Belumosudil_clad2, LYs_Belumosudil_clad3,
                                               LYs_Belumosudil_clad4 , LYs_Belumosudil_LTx)),
  QALYs.Belumosudil.undiscounted = rowSums(cbind(QALYs_FEV1.based_belumosudil, AE_disutility_belumosudil)),
  LYs.BSC.undiscounted = rowSums(cbind(LYs_BSC_clad1, LYs_BSC_clad2, LYs_BSC_clad3,
                                       LYs_BSC_clad4, LYs_BSC_LTx)),
  QALYs.BSC.undiscounted = rowSums(cbind(QALYs_FEV1.based_BSC, AE_disutility_BSC))
  
)
}

# -----------------------------------------------------
# Drug Costs
# -----------------------------------------------------

# Define a function to calculate the price per milligram (mg) for any drug
calculate_price_mg <- function(pack_price, absolute_reduction, pas_discount, discount, 
                               pack_size, strength_per_unit) {
  
  
  price_mg <- (pack_price - absolute_reduction) *           # Subtracting the absolute reduction from the pack price
    (1 - pas_discount) *                         # Applying the PAS discount (if any)
    (1 - discount) /                             # Applying the standard discount (if any)
    pack_size /                                  # Dividing by the pack size
    strength_per_unit                            # Dividing by the strength per unit
  
  return(price_mg)  # Return the calculated price per mg
}

# Use the function to calculate prices

# Belumosudil
price_mg_belumosudil <- calculate_price_mg(
  pack_price = pack_price_belumosudil, 
  absolute_reduction = absolute_reduction_belumosudil, 
  pas_discount = pas_discount_belumosudil, 
  discount = discount_belumosudil, 
  pack_size = pack_size_belumosudil, 
  strength_per_unit = strength_per_unit_belumosudil
)

# Azithromycin
price_mg_azithromycin <- calculate_price_mg(
  pack_price = pack_price_azithromycin, 
  absolute_reduction = absolute_reduction_azithromycin, 
  pas_discount = pas_discount_azithromycin, 
  discount = discount_azithromycin, 
  pack_size = pack_size_azithromycin, 
  strength_per_unit = strength_per_unit_azithromycin
)

# Omeprazole
price_mg_omeprazole <- calculate_price_mg(
  pack_price = pack_price_omeprazole, 
  absolute_reduction = absolute_reduction_omeprazole, 
  pas_discount = pas_discount_omeprazole, 
  discount = discount_omeprazole, 
  pack_size = pack_size_omeprazole, 
  strength_per_unit = strength_per_unit_omeprazole
)


# Function to calculate the drug cost for a specific cycle
calculate_drug_cost <- function(number_doses, price_mg, dose_mg, percentage_receiving_ppi, 
                                number_doses_omeprazole = 0, price_mg_omeprazole = 0, dose_mg_omeprazole = 0) {
  # Azithromycin drug cost calculation
  azithromycin_cost <- number_doses * price_mg * dose_mg
  
  # Omeprazole drug cost calculation (if PPI is being received)
  omeprazole_cost <- percentage_receiving_ppi * (number_doses_omeprazole * price_mg_omeprazole * dose_mg_omeprazole)
  
  # Total cost for the cycle (Azithromycin + Omeprazole)
  total_cost <- azithromycin_cost + omeprazole_cost
  
  return(total_cost)
}

# Function to calculate Belumosudil drug cost for a specific cycle
calculate_belumosudil_cost <- function(number_doses_belumosudil, price_mg_belumosudil, dose_mg_belumosudil, 
                                       cycle_cost_BSC) {
  # Belumosudil drug cost calculation
  belumosudil_cost <- number_doses_belumosudil * price_mg_belumosudil * dose_mg_belumosudil
  
  # Total cost for Belumosudil including the BSC cycle cost
  total_cost <- belumosudil_cost + cycle_cost_BSC
  
  return(total_cost)
}

# Calculate drug cost for the first cycle (BSC)
drug_cost_first_cycle_BSC <- calculate_drug_cost(
  number_doses = number_doses_azithromycin_first_cycle, 
  price_mg = price_mg_azithromycin, 
  dose_mg = dose_mg_azithromycin, 
  percentage_receiving_ppi = percentage_receiving_ppi,
  number_doses_omeprazole = number_doses_omeprazole_first_cycle,
  price_mg_omeprazole = price_mg_omeprazole,
  dose_mg_omeprazole = dose_mg_omeprazole
)

# Calculate drug cost for cycle 2 (BSC)
drug_cost_cycle_2_BSC <- calculate_drug_cost(
  number_doses = number_doses_azithromycin_cycle_2, 
  price_mg = price_mg_azithromycin, 
  dose_mg = dose_mg_azithromycin, 
  percentage_receiving_ppi = percentage_receiving_ppi,
  number_doses_omeprazole = number_doses_omeprazole_cycle_2,
  price_mg_omeprazole = price_mg_omeprazole,
  dose_mg_omeprazole = dose_mg_omeprazole
)

# Calculate drug cost for subsequent cycles (BSC)
drug_cost_subsequent_cycles_BSC <- calculate_drug_cost(
  number_doses = number_doses_azithromycin_subsequent_cycles, 
  price_mg = price_mg_azithromycin, 
  dose_mg = dose_mg_azithromycin, 
  percentage_receiving_ppi = percentage_receiving_ppi,
  number_doses_omeprazole = number_doses_omeprazole_subsequent_cycles,
  price_mg_omeprazole = price_mg_omeprazole,
  dose_mg_omeprazole = dose_mg_omeprazole
)

# Calculate Belumosudil drug cost for the first cycle
drug_cost_first_cycle_belumosudil <- calculate_belumosudil_cost(
  number_doses_belumosudil = number_doses_belumosudil_first_cycle, 
  price_mg_belumosudil = price_mg_belumosudil, 
  dose_mg_belumosudil = dose_mg_belumosudil, 
  cycle_cost_BSC = drug_cost_first_cycle_BSC
)

# Calculate Belumosudil drug cost for cycle 2
drug_cost_cycle_2_belumosudil <- calculate_belumosudil_cost(
  number_doses_belumosudil = number_doses_belumosudil_cycle_2, 
  price_mg_belumosudil = price_mg_belumosudil, 
  dose_mg_belumosudil = dose_mg_belumosudil, 
  cycle_cost_BSC = drug_cost_cycle_2_BSC
)

# Calculate Belumosudil drug cost for subsequent cycles
drug_cost_subsequent_cycles_belumosudil <- calculate_belumosudil_cost(
  number_doses_belumosudil = number_doses_belumosudil_subsequent_cycles, 
  price_mg_belumosudil = price_mg_belumosudil, 
  dose_mg_belumosudil = dose_mg_belumosudil, 
  cycle_cost_BSC = drug_cost_subsequent_cycles_BSC
)


# Function to calculate the price per mg/ml for any drug
calculate_price_mg_ml <- function(pack_price, discount, strength_per_unit, pack_size) {
  # Calculate the price per mg/ml for the drug
  price_mg_ml <- pack_price * (1 - discount) / strength_per_unit / pack_size
  return(price_mg_ml)
}

# Azathioprine
price_mg_ml_azathioprine <- calculate_price_mg_ml(
  pack_price = pack_price_azathioprine, 
  discount = discount_azathioprine, 
  strength_per_unit = strength_per_unit_azathioprine, 
  pack_size = pack_size_azathioprine
)

# MMF (Mycophenolate mofetil)
price_mg_ml_mmf <- calculate_price_mg_ml(
  pack_price = pack_price_mmf, 
  discount = discount_mmf, 
  strength_per_unit = strength_per_unit_mmf, 
  pack_size = pack_size_mmf
)

# ECP 
price_mg_ml_ecp <- calculate_price_mg_ml(
  pack_price = pack_price_ecp, 
  discount = discount_ecp, 
  strength_per_unit = strength_per_unit_ecp, 
  pack_size = pack_size_ecp
)

# Prednisone
price_mg_ml_prednisone <- calculate_price_mg_ml(
  pack_price = pack_price_prednisone, 
  discount = discount_prednisone, 
  strength_per_unit = strength_per_unit_prednisone, 
  pack_size = pack_size_prednisone
)

# Cyclosporine
price_mg_ml_cyclosporine <- calculate_price_mg_ml(
  pack_price = pack_price_cyclosporine, 
  discount = discount_cyclosporine, 
  strength_per_unit = strength_per_unit_cyclosporine, 
  pack_size = pack_size_cyclosporine
)

# Tacrolimus
price_mg_ml_tacrolimus <- calculate_price_mg_ml(
  pack_price = pack_price_tacrolimus, 
  discount = discount_tacrolimus, 
  strength_per_unit = strength_per_unit_tacrolimus, 
  pack_size = pack_size_tacrolimus
)

# Function to calculate disease management costs for a specific CLAD stage
calculate_disease_management_cycle <- function(
    azathioprine, price_mg_ml_azathioprine, drug_dose_mg_azathioprine,
    mmf, price_mg_ml_mmf, drug_dose_mg_mmf,
    ecp, price_mg_ml_ecp, drug_dose_mg_ecp, unit_cost_admin_ECP = 0,
    prednisone, price_mg_ml_prednisone, drug_dose_mg_prednisone,
    cyclosporine, price_mg_ml_cyclosporine, drug_dose_mg_cyclosporine,
    tacrolimus, price_mg_ml_tacrolimus, drug_dose_mg_tacrolimus
) {
  # Calculate the total cost for the specified CLAD stage
  total_cost <- sum(
    azathioprine * price_mg_ml_azathioprine * drug_dose_mg_azathioprine,
    mmf * price_mg_ml_mmf * drug_dose_mg_mmf,
    ecp * price_mg_ml_ecp * drug_dose_mg_ecp,
    prednisone * price_mg_ml_prednisone * drug_dose_mg_prednisone,
    cyclosporine * price_mg_ml_cyclosporine * drug_dose_mg_cyclosporine,
    tacrolimus * price_mg_ml_tacrolimus * drug_dose_mg_tacrolimus
  ) + ecp * unit_cost_admin_ECP
  
  return(total_cost)
}

# Function to calculate disease management costs (aligned with the SUMPRODUCT logic in Excel)
calculate_disease_management_cycle <- function(
    factors, # Vector of factors (e.g., proportion of patients or frequency of administration)
    prices,  # Vector of prices per unit (e.g., mg/ml)
    doses,   # Vector of doses (e.g., mg)
    admin_factor = 0, # Administrative factor (default = 0)
    admin_cost = 0    # Administrative cost per unit (default = 0)
) {
  # Calculate the main cost using element-wise multiplication and summation
  main_cost <- sum(factors * prices * doses)
  
  # Add the additional administrative cost
  total_cost <- main_cost + (admin_factor * admin_cost)
  
  return(total_cost)
}

# Disease management costs for CLAD 0-2
disease_management_cycle_clad0 <- calculate_disease_management_cycle(
  factors = c(clad_0_2_azathioprine, clad_0_2_mmf, clad_0_2_ecp, clad_0_2_prednisone, clad_0_2_cyclosporine, clad_0_2_tacrolimus),
  prices = c(price_mg_ml_azathioprine, price_mg_ml_mmf, price_mg_ml_ecp, price_mg_ml_prednisone, price_mg_ml_cyclosporine, price_mg_ml_tacrolimus),
  doses = c(drug_dose_mg_azathioprine, drug_dose_mg_mmf, drug_dose_mg_ecp, drug_dose_mg_prednisone, drug_dose_mg_cyclosporine, drug_dose_mg_tacrolimus),
  admin_factor = clad_0_2_ecp,  # Proportion of patients receiving ECP
  admin_cost = unit_cost_admin_ECP # Cost per unit administration of ECP
)

# Disease management costs for CLAD 1 and 2 (same as CLAD 0)
disease_management_cycle_clad1 <- disease_management_cycle_clad0
disease_management_cycle_clad2 <- disease_management_cycle_clad0

# Disease management costs for CLAD 3
disease_management_cycle_clad3 <- calculate_disease_management_cycle(
  factors = c(clad_3_azathioprine, clad_3_mmf, clad_3_ecp, clad_3_prednisone, clad_3_cyclosporine, clad_3_tacrolimus),
  prices = c(price_mg_ml_azathioprine, price_mg_ml_mmf, price_mg_ml_ecp, price_mg_ml_prednisone, price_mg_ml_cyclosporine, price_mg_ml_tacrolimus),
  doses = c(drug_dose_mg_azathioprine, drug_dose_mg_mmf, drug_dose_mg_ecp, drug_dose_mg_prednisone, drug_dose_mg_cyclosporine, drug_dose_mg_tacrolimus),
  admin_factor = clad_3_ecp,  # Proportion of patients receiving ECP
  admin_cost = unit_cost_admin_ECP # Cost per unit administration of ECP
)

# Disease management costs for CLAD 4
disease_management_cycle_clad4 <- calculate_disease_management_cycle(
  factors = c(clad_4_azathioprine, clad_4_mmf, clad_4_ecp, clad_4_prednisone, clad_4_cyclosporine, clad_4_tacrolimus),
  prices = c(price_mg_ml_azathioprine, price_mg_ml_mmf, price_mg_ml_ecp, price_mg_ml_prednisone, price_mg_ml_cyclosporine, price_mg_ml_tacrolimus),
  doses = c(drug_dose_mg_azathioprine, drug_dose_mg_mmf, drug_dose_mg_ecp, drug_dose_mg_prednisone, drug_dose_mg_cyclosporine, drug_dose_mg_tacrolimus),
  admin_factor = clad_4_ecp,  # Proportion of patients receiving ECP
  admin_cost = unit_cost_admin_ECP # Cost per unit administration of ECP
)

disease_management_cycle_LTx <- mean(c(disease_management_cycle_clad2, disease_management_cycle_clad3, disease_management_cycle_clad4))







belumosudil.1L.drug.costs <- rep(NA, nrow(df_FEV1trajectory))
belumosudil.1L.drug.costs[1] <- df_FEV1trajectory$Belumosudil.arm.1L[1] * drug_cost_first_cycle_belumosudil
belumosudil.1L.drug.costs[2] <- df_FEV1trajectory$Belumosudil.arm.1L[2] * drug_cost_cycle_2_belumosudil
belumosudil.1L.drug.costs[3:nrow(df_FEV1trajectory)] <- df_FEV1trajectory$Belumosudil.arm.1L[3:nrow(df_FEV1trajectory)] * drug_cost_subsequent_cycles_belumosudil

belumosudil.2L.drug.costs <- rep(NA, nrow(df_FEV1trajectory))
belumosudil.2L.drug.costs[1] <- df_FEV1trajectory$Belumosudil.arm.2L.BSC[1] * drug_cost_first_cycle_BSC
belumosudil.2L.drug.costs[2] <- df_FEV1trajectory$Belumosudil.arm.2L.BSC[2] * drug_cost_cycle_2_BSC
belumosudil.2L.drug.costs[3:nrow(df_FEV1trajectory)] <- df_FEV1trajectory$Belumosudil.arm.2L.BSC[3:nrow(df_FEV1trajectory)] * drug_cost_subsequent_cycles_BSC



df_costs_payoffs <- data.frame(
  
  Belumosudil.1L.drug.costs = belumosudil.1L.drug.costs,
  Belumosudil.2L.drug.costs = belumosudil.2L.drug.costs,
  Total.Belumosudil.drug.costs = rowSums(cbind(belumosudil.1L.drug.costs,belumosudil.2L.drug.costs ))
)




