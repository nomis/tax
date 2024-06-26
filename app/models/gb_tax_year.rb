# SPDX-FileCopyrightText: 2021,2024 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

class GBTaxYear < ApplicationRecord
  has_many :income_months, class_name: "GBIncomeMonth", foreign_key: "year_id", inverse_of: :year
  has_many :pension_contributions, class_name: "GBPensionContribution", foreign_key: "year_id", inverse_of: :year

  validates :year, presence: true, uniqueness: true
  validate :validate_tax_values

  def name
    "#{year}/#{(year + 1) % 100}"
  end

  def uk_taxpayer?
    self.taxpayer_type == "GB-UKM"
  end

  def sco_taxpayer?
    self.taxpayer_type == "GB-SCT"
  end

  def total_income
    income_months.sum(&:total_income)
  end

  def paye_net_pension_contributions
    income_months.sum(&:net_pension)
  end

  def sipp_net_pension_contributions
    pension_contributions.sum(&:net_amount)
  end

  def total_net_pension_contributions
    paye_net_pension_contributions + sipp_net_pension_contributions
  end

  def total_flexible_remuneration
    income_months.sum(&:flexible_remuneration)
  end

  def total_benefit_in_kind
    income_months.sum(&:benefit_in_kind)
  end

  def total_employer_pension_contributions
    income_months.sum(&:employer_pension)
  end

  def total_paye_paid
    income_months.sum(&:paye_paid)
  end

  def below_higher_band
    personal_allowance + basic_band
  end

  def below_sco_basic_band
    personal_allowance + (sco_starter_band || 0)
  end

  def below_sco_intermediate_band
    below_sco_basic_band + sco_basic_band
  end

  def below_sco_higher_band
    below_sco_intermediate_band + (sco_intermediate_band || 0)
  end

  def below_sco_advanced_band
    below_sco_higher_band + sco_higher_band
  end

  private

  def validate_tax_values
    errors.add(:personal_allowance, "missing") if personal_allowance.nil?
    errors.add(:basic_band, "missing") if basic_band.nil?
    errors.add(:basic_rate, "missing") if basic_rate.nil?
    errors.add(:higher_band, "missing") if higher_band.nil?
    errors.add(:higher_rate, "missing") if higher_rate.nil?
    errors.add(:additional_rate, "missing") if additional_rate.nil?
    errors.add(:pension_annual_allowance, "missing") if pension_annual_allowance.nil?

    errors.add(:starting_rate_for_savings, "missing") if starting_rate_for_savings.nil?
    errors.add(:starting_band_for_savings, "missing") if starting_band_for_savings.nil?

    errors.add(:dividend_basic_rate, "missing") if dividend_basic_rate.nil?
    errors.add(:dividend_higher_rate, "missing") if dividend_higher_rate.nil?
    errors.add(:dividend_additional_rate, "missing") if dividend_additional_rate.nil?

    valid_taxpayers = ["GB-UKM"]

    if year < 2016
      errors.add(:tax_free_interest_at_basic_rate, "does not exist") if !tax_free_interest_at_basic_rate.nil?
      errors.add(:tax_free_interest_at_higher_rate, "does not exist") if !tax_free_interest_at_higher_rate.nil?

      errors.add(:dividend_allowance, "does not exist") if !dividend_allowance.nil?

      errors.add(:pension_annual_allowance_tapering_threshold_income, "does not exist") if !pension_annual_allowance_tapering_threshold_income.nil?
      errors.add(:pension_annual_allowance_tapering_adjusted_income, "does not exist") if !pension_annual_allowance_tapering_adjusted_income.nil?
      errors.add(:pension_annual_allowance_tapering_min_reduced, "does not exist") if !pension_annual_allowance_tapering_min_reduced.nil?
    else
      valid_taxpayers << "GB-SCT"

      errors.add(:tax_free_interest_at_basic_rate, "missing") if tax_free_interest_at_basic_rate.nil?
      errors.add(:tax_free_interest_at_higher_rate, "missing") if tax_free_interest_at_higher_rate.nil?

      errors.add(:dividend_allowance, "missing") if dividend_allowance.nil?

      errors.add(:pension_annual_allowance_tapering_threshold_income, "missing") if pension_annual_allowance_tapering_threshold_income.nil?
      errors.add(:pension_annual_allowance_tapering_adjusted_income, "missing") if pension_annual_allowance_tapering_adjusted_income.nil?
      errors.add(:pension_annual_allowance_tapering_min_reduced, "missing") if pension_annual_allowance_tapering_min_reduced.nil?
    end

    if year < 2017
      errors.add(:sco_basic_band, "does not exist") if !sco_basic_band.nil?
      errors.add(:sco_basic_rate, "does not exist") if !sco_basic_rate.nil?
      errors.add(:sco_higher_band, "does not exist") if !sco_higher_band.nil?
      errors.add(:sco_higher_rate, "does not exist") if !sco_higher_rate.nil?
    else
      errors.add(:sco_basic_band, "missing") if sco_basic_band.nil?
      errors.add(:sco_basic_rate, "missing") if sco_basic_rate.nil?
      errors.add(:sco_higher_band, "missing") if sco_higher_band.nil?
      errors.add(:sco_higher_rate, "missing") if sco_higher_rate.nil?
    end

    if year == 2017
      errors.add(:sco_additional_rate, "missing") if sco_additional_rate.nil?
    else
      errors.add(:sco_additional_rate, "does not exist") if !sco_additional_rate.nil?
    end

    if year < 2018
      errors.add(:sco_starter_band, "does not exist") if !sco_starter_band.nil?
      errors.add(:sco_starter_rate, "does not exist") if !sco_starter_rate.nil?
      errors.add(:sco_intermediate_band, "does not exist") if !sco_intermediate_band.nil?
      errors.add(:sco_intermediate_rate, "does not exist") if !sco_intermediate_rate.nil?
      errors.add(:sco_top_rate, "does not exist") if !sco_top_rate.nil?
    else
      errors.add(:sco_starter_band, "missing") if sco_starter_band.nil?
      errors.add(:sco_starter_rate, "missing") if sco_starter_rate.nil?
      errors.add(:sco_intermediate_band, "missing") if sco_intermediate_band.nil?
      errors.add(:sco_intermediate_rate, "missing") if sco_intermediate_rate.nil?
      errors.add(:sco_top_rate, "missing") if sco_top_rate.nil?
    end

    if year < 2024
      errors.add(:sco_advanced_band, "does not exist") if !sco_advanced_band.nil?
      errors.add(:sco_advanced_rate, "does not exist") if !sco_advanced_rate.nil?
    else
      errors.add(:sco_advanced_band, "missing") if sco_advanced_band.nil?
      errors.add(:sco_advanced_rate, "missing") if sco_advanced_rate.nil?
    end

    errors.add(:taxpayer_type, "invalid") if !valid_taxpayers.include? taxpayer_type
  end
end
