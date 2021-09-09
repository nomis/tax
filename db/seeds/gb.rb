# SPDX-FileCopyrightText: 2021 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

y = GBTaxYear.find_or_create_by(year: 2012)
y.personal_allowance = 8105

y.basic_rate = 20
y.basic_band = 42475 - y.personal_allowance
raise y.basic_band.to_s if y.basic_band != 34370
y.higher_rate = 40
y.higher_band = 150000 - (y.below_higher_band - y.personal_allowance)
raise y.higher_band.to_s if y.higher_band != 115630
y.additional_rate = 45

y.pension_annual_allowance = 50000

y.starting_rate_for_savings = 10
y.starting_band_for_savings = 2710
y.save!

y = GBTaxYear.find_or_create_by(year: 2013)
y.personal_allowance = 9440

y.basic_rate = 20
y.basic_band = 41450 - y.personal_allowance
raise y.basic_band.to_s if y.basic_band != 32010
y.higher_rate = 40
y.higher_band = 150000 - (y.below_higher_band - y.personal_allowance)
raise y.higher_band.to_s if y.higher_band != 117990
y.additional_rate = 45

y.pension_annual_allowance = 50000

y.starting_rate_for_savings = 10
y.starting_band_for_savings = 2790
y.save!

y = GBTaxYear.find_or_create_by(year: 2014)
y.personal_allowance = 10000

y.basic_rate = 20
y.basic_band = 41865 - y.personal_allowance
raise y.basic_band.to_s if y.basic_band != 31865
y.higher_rate = 40
y.higher_band = 150000 - (y.below_higher_band - y.personal_allowance)
raise y.higher_band.to_s if y.higher_band != 118135
y.additional_rate = 45

y.pension_annual_allowance = 40000

y.starting_rate_for_savings = 10
y.starting_band_for_savings = 2880
y.save!

y = GBTaxYear.find_or_create_by(year: 2015)
y.personal_allowance = 10600

y.basic_rate = 20
y.basic_band = 42385 - y.personal_allowance
raise y.basic_band.to_s if y.basic_band != 31785
y.higher_rate = 40
y.higher_band = 150000 - (y.below_higher_band - y.personal_allowance)
raise y.higher_band.to_s if y.higher_band != 118215
y.additional_rate = 45

y.pension_annual_allowance = 80000

y.starting_rate_for_savings = 0
y.starting_band_for_savings = 5000
y.save!

y = GBTaxYear.find_or_create_by(year: 2016)
y.personal_allowance = 11000

y.basic_rate = 20
y.basic_band = 43000 - y.personal_allowance
raise y.basic_band.to_s if y.basic_band != 32000
y.higher_rate = 40
y.higher_band = 150000 - (y.below_higher_band - y.personal_allowance)
raise y.higher_band.to_s if y.higher_band != 118000
y.additional_rate = 45

y.pension_annual_allowance = 40000
y.pension_annual_allowance_tapering_threshold_income = 110000
y.pension_annual_allowance_tapering_adjusted_income = 150000
y.pension_annual_allowance_tapering_min_reduced = 10000

y.tax_free_interest_at_basic_rate = 1000
y.tax_free_interest_at_higher_rate = 500
y.starting_rate_for_savings = 0
y.starting_band_for_savings = 5000
y.save!

y = GBTaxYear.find_or_create_by(year: 2017)
y.personal_allowance = 11500

y.basic_rate = 20
y.basic_band = 45000 - y.personal_allowance
raise y.basic_band.to_s if y.basic_band != 33500
y.higher_rate = 40
y.higher_band = 150000 - (y.below_higher_band - y.personal_allowance)
raise y.higher_band.to_s if y.higher_band != 116500
y.additional_rate = 45

y.pension_annual_allowance = 40000
y.pension_annual_allowance_tapering_threshold_income = 110000
y.pension_annual_allowance_tapering_adjusted_income = 150000
y.pension_annual_allowance_tapering_min_reduced = 10000

y.tax_free_interest_at_basic_rate = 1000
y.tax_free_interest_at_higher_rate = 500
y.starting_rate_for_savings = 0
y.starting_band_for_savings = 5000

y.sco_starter_rate = 0
y.sco_starter_band = 0
y.sco_basic_rate = 20
y.sco_basic_band = 43000 - y.below_sco_basic_band
raise y.sco_basic_band.to_s if y.sco_basic_band != 31500
y.sco_intermediate_rate = 0
y.sco_intermediate_band = 0
raise y.below_sco_higher_band.to_s if y.below_sco_higher_band != 43000
y.sco_higher_rate = 40
y.sco_higher_band = 150000 - (y.below_sco_higher_band - y.personal_allowance)
raise y.sco_higher_band.to_s if y.sco_higher_band != 118500
y.sco_additional_rate = 45
y.save!

y = GBTaxYear.find_or_create_by(year: 2018)
y.personal_allowance = 11850

y.basic_rate = 20
y.basic_band = 46350 - y.personal_allowance
raise y.basic_band.to_s if y.basic_band != 34500
y.higher_rate = 40
y.higher_band = 150000 - (y.below_higher_band - y.personal_allowance)
raise y.higher_band.to_s if y.higher_band != 115500
y.additional_rate = 45

y.pension_annual_allowance = 40000
y.pension_annual_allowance_tapering_threshold_income = 110000
y.pension_annual_allowance_tapering_adjusted_income = 150000
y.pension_annual_allowance_tapering_min_reduced = 10000

y.tax_free_interest_at_basic_rate = 1000
y.tax_free_interest_at_higher_rate = 500
y.starting_rate_for_savings = 0
y.starting_band_for_savings = 5000

y.sco_starter_rate = 19
y.sco_starter_band = 13850 - y.personal_allowance
raise y.sco_starter_band.to_s if y.sco_starter_band != 2000
y.sco_basic_rate = 20
y.sco_basic_band = 24000 - y.below_sco_basic_band
raise y.sco_basic_band.to_s if y.sco_basic_band != 10150
y.sco_intermediate_rate = 21
y.sco_intermediate_band = 43430 - y.below_sco_intermediate_band
raise y.sco_intermediate_band.to_s if y.sco_intermediate_band != 19430
raise y.below_sco_higher_band.to_s if y.below_sco_higher_band != 43430
y.sco_higher_rate = 41
y.sco_higher_band = 150000 - (y.below_sco_higher_band - y.personal_allowance)
raise y.sco_higher_band.to_s if y.sco_higher_band != 118420
y.sco_additional_rate = 46
y.save!

y = GBTaxYear.find_or_create_by(year: 2019)
y.personal_allowance = 12500

y.basic_rate = 20
y.basic_band = 50000 - y.personal_allowance
raise y.basic_band.to_s if y.basic_band != 37500
y.higher_rate = 40
y.higher_band = 150000 - (y.below_higher_band - y.personal_allowance)
raise y.higher_band.to_s if y.higher_band != 112500
y.additional_rate = 45

y.pension_annual_allowance = 40000
y.pension_annual_allowance_tapering_threshold_income = 110000
y.pension_annual_allowance_tapering_adjusted_income = 150000
y.pension_annual_allowance_tapering_min_reduced = 10000

y.tax_free_interest_at_basic_rate = 1000
y.tax_free_interest_at_higher_rate = 500
y.starting_rate_for_savings = 0
y.starting_band_for_savings = 5000

y.sco_starter_rate = 19
y.sco_starter_band = 14549 - y.personal_allowance
raise y.sco_starter_band.to_s if y.sco_starter_band != 2049
y.sco_basic_rate = 20
y.sco_basic_band = 24944 - y.below_sco_basic_band
raise y.sco_basic_band.to_s if y.sco_basic_band != 10395
y.sco_intermediate_rate = 21
y.sco_intermediate_band = 43430 - y.below_sco_intermediate_band
raise y.sco_intermediate_band.to_s if y.sco_intermediate_band != 18486
raise y.below_sco_higher_band.to_s if y.below_sco_higher_band != 43430
y.sco_higher_rate = 41
y.sco_higher_band = 150000 - (y.below_sco_higher_band - y.personal_allowance)
raise y.sco_higher_band.to_s if y.sco_higher_band != 119070
y.sco_additional_rate = 46
y.save!

y = GBTaxYear.find_or_create_by(year: 2020)
y.personal_allowance = 12500

y.basic_rate = 20
y.basic_band = 50000 - y.personal_allowance
raise y.basic_band.to_s if y.basic_band != 37500
y.higher_rate = 40
y.higher_band = 150000 - (y.below_higher_band - y.personal_allowance)
raise y.higher_band.to_s if y.higher_band != 112500
y.additional_rate = 45

y.pension_annual_allowance = 40000
y.pension_annual_allowance_tapering_threshold_income = 240000
y.pension_annual_allowance_tapering_adjusted_income = 200000
y.pension_annual_allowance_tapering_min_reduced = 4000

y.tax_free_interest_at_basic_rate = 1000
y.tax_free_interest_at_higher_rate = 500
y.starting_rate_for_savings = 0
y.starting_band_for_savings = 5000

y.sco_starter_rate = 19
y.sco_starter_band = 14585 - y.personal_allowance
raise y.sco_starter_band.to_s if y.sco_starter_band != 2085
y.sco_basic_rate = 20
y.sco_basic_band = 25158 - y.below_sco_basic_band
raise y.sco_basic_band.to_s if y.sco_basic_band != 10573
y.sco_intermediate_rate = 21
y.sco_intermediate_band = 43430 - y.below_sco_intermediate_band
raise y.sco_intermediate_band.to_s if y.sco_intermediate_band != 18272
raise y.below_sco_higher_band.to_s if y.below_sco_higher_band != 43430
y.sco_higher_rate = 41
y.sco_higher_band = 150000 - (y.below_sco_higher_band - y.personal_allowance)
raise y.sco_higher_band.to_s if y.sco_higher_band != 119070
y.sco_additional_rate = 46
y.save!

y = GBTaxYear.find_or_create_by(year: 2021)
y.personal_allowance = 12570

y.basic_rate = 20
y.basic_band = 50270 - y.personal_allowance
raise y.basic_band.to_s if y.basic_band != 37700
y.higher_rate = 40
y.higher_band = 150000 - (y.below_higher_band - y.personal_allowance)
raise y.higher_band.to_s if y.higher_band != 112300
y.additional_rate = 45

y.pension_annual_allowance = 40000
y.pension_annual_allowance_tapering_threshold_income = 240000
y.pension_annual_allowance_tapering_adjusted_income = 200000
y.pension_annual_allowance_tapering_min_reduced = 4000

y.tax_free_interest_at_basic_rate = 1000
y.tax_free_interest_at_higher_rate = 500
y.starting_rate_for_savings = 0
y.starting_band_for_savings = 5000

y.sco_starter_rate = 19
y.sco_starter_band = 14667 - y.personal_allowance
raise y.sco_starter_band.to_s if y.sco_starter_band != 2097
y.sco_basic_rate = 20
y.sco_basic_band = 25296 - y.below_sco_basic_band
raise y.sco_basic_band.to_s if y.sco_basic_band != 10629
y.sco_intermediate_rate = 21
y.sco_intermediate_band = 43662 - y.below_sco_intermediate_band
raise y.sco_intermediate_band.to_s if y.sco_intermediate_band != 18366
raise y.below_sco_higher_band.to_s if y.below_sco_higher_band != 43662
y.sco_higher_rate = 41
y.sco_higher_band = 150000 - (y.below_sco_higher_band - y.personal_allowance)
raise y.sco_higher_band.to_s if y.sco_higher_band != 118908
y.sco_additional_rate = 46
y.save!

y = GBTaxYear.find_or_create_by(year: 2022)
y.personal_allowance = 12570

y.basic_rate = 20
y.basic_band = 50270 - y.personal_allowance
raise y.basic_band.to_s if y.basic_band != 37700
y.higher_rate = 40
y.higher_band = 150000 - (y.below_higher_band - y.personal_allowance)
raise y.higher_band.to_s if y.higher_band != 112300
y.additional_rate = 45

y.pension_annual_allowance = 40000
y.pension_annual_allowance_tapering_threshold_income = 240000
y.pension_annual_allowance_tapering_adjusted_income = 200000
y.pension_annual_allowance_tapering_min_reduced = 4000

y.tax_free_interest_at_basic_rate = 1000
y.tax_free_interest_at_higher_rate = 500
y.starting_rate_for_savings = 0
y.starting_band_for_savings = 5000

y.sco_starter_rate = 19
y.sco_starter_band = 14667 - y.personal_allowance
raise y.sco_starter_band.to_s if y.sco_starter_band != 2097
y.sco_basic_rate = 20
y.sco_basic_band = 25296 - y.below_sco_basic_band
raise y.sco_basic_band.to_s if y.sco_basic_band != 10629
y.sco_intermediate_rate = 21
y.sco_intermediate_band = 43662 - y.below_sco_intermediate_band
raise y.sco_intermediate_band.to_s if y.sco_intermediate_band != 18366
raise y.below_sco_higher_band.to_s if y.below_sco_higher_band != 43662
y.sco_higher_rate = 41
y.sco_higher_band = 150000 - (y.below_sco_higher_band - y.personal_allowance)
raise y.sco_higher_band.to_s if y.sco_higher_band != 118908
y.sco_additional_rate = 46
y.save!
