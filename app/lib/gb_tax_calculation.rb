# SPDX-FileCopyrightText: 2021 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

class GBTaxCalculation
  include ActionView::Helpers::NumberHelper

  def initialize(year)
    @data = GBTaxYear.find_by(year: year)
    @run = false
  end

  def inputs
    run
    @inputs
  end

  def calculations
    run
    @calculations
  end

  def outputs
    run
    @outputs
  end

  def basic_rate_non_savings_non_dividend
    if @data.sco_taxpayer?
      @data.sco_basic_rate
    else
      @data.basic_rate
    end
  end

  def basic_rate_savings_interest
    @data.basic_rate
  end

  def basic_rate_gift_aid
    @data.basic_rate
  end

  def basic_rate_pension_contributions
    @data.basic_rate
  end

  def savings_nil_rate_band(calc_basic_band_increase)
    raise if @data.year < 2016

    if total_income > @data.personal_allowance + @data.basic_band + calc_basic_band_increase
      @data.tax_free_interest_at_higher_rate
    else
      @data.tax_free_interest_at_basic_rate
    end
  end

  def savings_starting_rate_band
    [0, @data.starting_band_for_savings - taxable_income_non_savings_non_dividend].max
  end

  def employment_income
    [0, @data.total_income.floor - @data.allowable_expenses.ceil].max
  end

  def total_interest
    @data.gross_interest.floor \
      + (@data.net_interest.floor / (1 - basic_rate_savings_interest / 100)).floor
  end

  def total_dividends
    0
  end

  def total_income
    employment_income + total_interest
  end

  def adjusted_income
    total_income + @data.total_employer_pension_contributions
  end

  def threshold_income(calc_pension_contributions = total_gross_pension_contributions)
    total_income - calc_pension_contributions + @data.total_flexible_remuneration
  end

  def pension_annual_allowance_available(calc_pension_contributions = total_gross_pension_contributions)
    if @data.year >= 2017 && \
        threshold_income(calc_pension_contributions) >= @data.pension_annual_allowance_tapering_threshold_income && \
        adjusted_income > @data.pension_annual_allowance_tapering_adjusted_income
      [@data.pension_annual_allowance_tapering_min_reduced,
        @data.pension_annual_allowance - ((@data.pension_annual_allowance_tapering_adjusted_income - adjusted_income) / 2).floor].max
    else
      @data.pension_annual_allowance
    end
  end

  def pension_annual_allowance_used(calc_pension_contributions = total_gross_pension_contributions)
    calc_pension_contributions + @data.total_employer_pension_contributions.ceil
  end

  def pension_annual_allowance_remaining(calc_pension_contributions = total_gross_pension_contributions)
    [0,
      pension_annual_allowance_available(calc_pension_contributions) \
        - pension_annual_allowance_used(calc_pension_contributions)].max
  end

  def pension_annual_allowance_exceeded(calc_pension_contributions = total_gross_pension_contributions)
    0 - [0,
      pension_annual_allowance_available(calc_pension_contributions) \
        - pension_annual_allowance_used(calc_pension_contributions)].min
  end

  def pension_annual_allowance_available_with_previous_years(calc_pension_contributions = total_gross_pension_contributions)
    previous_years = (1..3).map { |offset| GBTaxYear.find_by(year: @data.year - offset) }.reject(&:nil?)
    pension_annual_allowance_available(calc_pension_contributions) \
      + previous_years.sum { |previous| GBTaxCalculation.new(previous.year).pension_annual_allowance_remaining }
  end

  def pension_annual_allowance_remaining_with_previous_years(calc_pension_contributions = total_gross_pension_contributions)
    pension_annual_allowance_available_with_previous_years(calc_pension_contributions) - pension_annual_allowance_used(calc_pension_contributions)
  end

  def pension_annual_allowance_exceeded_with_previous_years(calc_pension_contributions = total_gross_pension_contributions)
    0 - [0,
          pension_annual_allowance_available_with_previous_years(calc_pension_contributions) \
            - pension_annual_allowance_used(calc_pension_contributions)].min
  end

  def taxable_income
    [0, total_income - @data.personal_allowance].max
  end

  def taxable_income_non_savings_non_dividend
    [0, employment_income - @data.personal_allowance].max
  end

  def taxable_income_savings_dividend
    [0, (total_interest + total_dividends) - [0, @data.personal_allowance - employment_income].max].max
  end

  def gross_gift_aid
    (@data.net_gift_aid.ceil / (1 - basic_rate_gift_aid / 100)).ceil
  end

  def paye_gross_pension_contributions
    (@data.paye_net_pension_contributions / (1 - basic_rate_pension_contributions / 100))
  end

  def sipp_gross_pension_contributions
    (@data.sipp_net_pension_contributions / (1 - basic_rate_pension_contributions / 100))
  end

  def total_gross_pension_contributions
    (@data.total_net_pension_contributions / (1 - basic_rate_pension_contributions / 100)).ceil
  end

  def basic_rate_tax_relief
    gross_gift_aid + total_gross_pension_contributions
  end

  private

  def run
    return if @run
    @run ||= true

    @inputs = [
      element("Pay from all employments", @data.total_income.floor, :amount, [:comparable]),
      element("minus Allowable Expenses", @data.allowable_expenses.ceil, :amount, [:comparable]),
      element("Total from all employments", employment_income, :amount, [:comparable]),
      element,
      element("Gross Interest", @data.gross_interest, :amount),
      element("Net Interest", @data.net_interest, :amount),
      element("Interest (UK)", total_interest, :amount, [:comparable]),
      element,
      element("Total income received", total_income, :amount, [:comparable]),
      element("minus Personal Allowance", @data.personal_allowance, :amount, [:comparable]),
      element("Total income on which tax is due", taxable_income, :amount, [:comparable]),
      element("Income: non-savings, non-dividend", taxable_income_non_savings_non_dividend, :amount, [:indent]),
      element("Income: savings and dividend", taxable_income_savings_dividend, :amount, [:indent]),
      element,
      element("Gift Aid", @data.net_gift_aid, :amount),
      element("Basic Rate increase for Gift Aid", gross_gift_aid, :amount, [:comparable]),
      element,
      element("PAYE Pension Contributions", paye_gross_pension_contributions, :amount),
      element("SIPP Contributions", sipp_gross_pension_contributions, :amount),
      element("Basic Rate increase for Pension Contributions", total_gross_pension_contributions, :amount, [:comparable]),
      element,
      element("Employer Pension Contributions", @data.total_employer_pension_contributions, :amount),
    ]

    @calculations = []

    initial = calculation("Initial Calculation", 0, 0)
    @calculations << initial[:elements]

    paye_pension = calculation("Without SIPP Calculation",
      basic_rate_tax_relief - sipp_gross_pension_contributions,
      paye_gross_pension_contributions.ceil)
    @calculations << paye_pension[:elements]

    final = calculation("Final Pension Calculation")
    @calculations << final[:elements]

    @outputs = []

    higher_income = if @data.year >= 2017 && @data.sco_taxpayer?
      [
        paye_pension[:non_savings_non_dividend_higher_income],
        paye_pension[:savings_dividend_higher_income]
      ].max
    else
      paye_pension[:higher_income]
    end

    min_sipp = higher_income
    max_sipp = [paye_pension[:pension_annual_allowance_remaining],
      total_income - (basic_rate_tax_relief - sipp_gross_pension_contributions)].min
    target_sipp = [paye_pension[:pension_annual_allowance_remaining], higher_income].min

    outputs << ["SIPP Pension Contributions",
      [
        element(nil, ["Gross", "Net"], nil, [:headings]),
        element("Minimum", [min_sipp, min_sipp * (1 - basic_rate_pension_contributions / 100)], :amount),
        element("Maximum", [max_sipp, max_sipp * (1 - basic_rate_pension_contributions / 100)], :amount),
        element,
        element("Target", [target_sipp, target_sipp * (1 - basic_rate_pension_contributions / 100)], :amount),
        element("Actual", [sipp_gross_pension_contributions, @data.sipp_net_pension_contributions], :amount),
        element("Difference", [sipp_gross_pension_contributions - target_sipp,
          @data.sipp_net_pension_contributions - target_sipp * (1 - basic_rate_pension_contributions / 100)], :amount),
      ]
    ]

    outputs << ["Remaining tax band below higher rate",
      if @data.year >= 2017 && @data.sco_taxpayer?
        [
          element("Non-savings, non-dividend", final[:non_savings_non_dividend_remaining_below_higher], :amount),
          element("Savings and dividend", final[:savings_dividend_remaining_below_higher], :amount),
        ]
      else
        [
          element("All income", final[:remaining_below_higher], :amount),
        ]
      end
    ]
  end

  def element(name = nil, values = [], formats = nil, markers = [])
    if !values.is_a? Array
      values = [values]
    end

    if !formats.is_a? Array
      formats = [formats] * values.size
    end

    values = values.each_with_index.map do |value, index|
      case formats[index]
      when :amount
        "£" + number_with_precision(value, precision: 2, delimiter: ",")
      when :percent
        number_with_precision(value, precision: 2) + "%"
      else
        value
      end
    end

    {
      name: name,
      values: values,
      markers: markers
    }
  end

  def allocate_to_bands(bands, rates, amount)
    allocated = {}
    remaining = bands.dup

    bands.each do |key, value|
      allocation = 0
      if amount > 0
        allocation += [amount, value].min
        remaining[key] -= allocation
        amount -= allocation
      end
      allocated[key] = [allocation, (allocation * (rates[key] / 100)).round(2)]
    end

    [allocated, remaining]
  end

  def remaining_allocation(bands, below)
    total = 0
    bands.each do |key, value|
      break if key == below
      total += value
    end
    total
  end

  def total_allocated(allocateds, from)
    total = nil
    allocateds.each do |allocated|
      subtotal = nil
      allocated.each do |key, value|
        subtotal = [0, 0] if key == from
        subtotal[0] += value[0] if !subtotal.nil?
        subtotal[1] += value[1] if !subtotal.nil?
      end

      if !subtotal.nil?
        total = [0, 0] if total.nil?
        total[0] += subtotal[0]
        total[1] += subtotal[1]
      end
    end
    total
  end

  def elements_for_allocation(names, bands, rates, allocated, discarded = false)
    elements = []
    markers = []
    markers << :discarded if discarded

    elements << element("", ["Band", "Rate", "Income", "Tax"], nil, [:indent, :headings] + markers)
    names.each do |key, name|
      elements << element(name,
        [bands[key], rates[key]] + allocated[key],
        [:amount, :percent, :amount, :amount],
        [:indent] + markers + (key == :higher ? [:higher] : []))
    end

    elements
  end

  def calculation(name, calc_basic_band_increase = basic_rate_tax_relief, calc_pension_contributions = total_gross_pension_contributions)
    result = {}
    elements = []

    elements << element("Basic Rate limit increase", calc_basic_band_increase, :amount)
    elements << element

    if @data.year >= 2017
      sco_emp_names = {
        personal_allowance: "Personal Allowance",
        starter: "Starter Rate",
        basic: "Basic Rate",
        intermediate: "Intermediate Rate",
        higher: "Higher Rate",
        additional: @data.year < 2018 ? "Additional Rate" : "Top Rate",
      }

      sco_emp_bands = {
        personal_allowance: @data.personal_allowance,
        starter: @data.sco_starter_band,
        basic: @data.sco_basic_band + calc_basic_band_increase,
        intermediate: @data.sco_intermediate_band,
        higher: @data.sco_higher_band,
        additional: "+Infinity".to_d,
      }

      sco_emp_rates = {
        personal_allowance: 0,
        starter: @data.sco_starter_rate,
        basic: @data.sco_basic_rate,
        intermediate: @data.sco_intermediate_rate,
        higher: @data.sco_higher_rate,
        additional: @data.sco_additional_rate,
      }

      sco_emp_allocated, sco_emp_remaining = allocate_to_bands(sco_emp_bands, sco_emp_rates, employment_income)
    end

    emp_names = {
      personal_allowance: "Personal Allowance",
      basic: "Basic Rate",
      higher: "Higher Rate",
      additional: "Additional Rate",
    }

    emp_bands = {
      personal_allowance: @data.personal_allowance,
      basic: @data.basic_band + calc_basic_band_increase,
      higher: @data.higher_band,
      additional: "+Infinity".to_d,
    }

    emp_rates = {
      personal_allowance: 0,
      basic: @data.basic_rate,
      higher: @data.higher_rate,
      additional: @data.additional_rate,
    }

    emp_allocated, emp_remaining = allocate_to_bands(emp_bands, emp_rates, employment_income)

    elements << element("Non-savings, non-dividend", nil, nil, [:heading])

    if @data.year >= 2017 && @data.sco_taxpayer?
      elements += elements_for_allocation(sco_emp_names, sco_emp_bands, sco_emp_rates, sco_emp_allocated)
    else
      elements += elements_for_allocation(emp_names, emp_bands, emp_rates, emp_allocated)
    end
    elements << element

    sav_names = {
      personal_allowance: "Personal Allowance",
    }
    sav_names[:nil_rate] = "Personal Savings Allowance" if @data.year >= 2016
    sav_names.merge!({
      starting_savings: "Starting Savings Rate",
      basic: "Basic Rate",
      higher: "Higher Rate",
      additional: "Additional Rate",
    })

    sav_bands = {
      personal_allowance: emp_remaining[:personal_allowance],
    }
    sav_bands[:nil_rate] = savings_nil_rate_band(calc_basic_band_increase) if @data.year >= 2016
    sav_bands.merge!({
      starting_savings: savings_starting_rate_band,
      basic: emp_remaining[:basic],
      higher: emp_remaining[:higher],
      additional: emp_remaining[:additional],
    })

    sav_rates = {
      personal_allowance: 0,
      nil_rate: 0,
      starting_savings: @data.starting_rate_for_savings,
      basic: @data.basic_rate,
      higher: @data.higher_rate,
      additional: @data.additional_rate,
    }

    sav_allocated, sav_remaining = allocate_to_bands(sav_bands, sav_rates, total_interest)

    elements << element("Savings and dividend", nil, nil, [:heading])

    if @data.year >= 2017 && @data.sco_taxpayer?
      elements += elements_for_allocation(emp_names, emp_bands, emp_rates, emp_allocated, true)
      elements << element(nil, nil, nil, [:discarded])
    end
    elements += elements_for_allocation(sav_names, sav_bands, sav_rates, sav_allocated)

    # Pension Annual Allowance rules before 2016 not supported
    if @data.year >= 2016
      elements << element
      elements << element("Pension Annual Allowance", nil, nil, [:heading])
      elements << element("Employee Pension Contributions", calc_pension_contributions, :amount, [:indent])
      elements << element("Employer Pension Contributions", @data.total_employer_pension_contributions.ceil, :amount, [:indent])
      elements << element
      elements << element("", ["This Year", "All Years"], nil, [:indent, :headings])
      elements << element("Available",
        [pension_annual_allowance_available(calc_pension_contributions),
          pension_annual_allowance_available_with_previous_years(calc_pension_contributions)], :amount, [:indent])
      elements << element("Used",
        [pension_annual_allowance_used(calc_pension_contributions),
          pension_annual_allowance_used(calc_pension_contributions)], :amount, [:indent])
      elements << element("Remaining",
        [pension_annual_allowance_remaining(calc_pension_contributions),
          pension_annual_allowance_remaining_with_previous_years(calc_pension_contributions)], :amount, [:indent])
      elements << element("Exceeded",
        [pension_annual_allowance_exceeded(calc_pension_contributions),
          pension_annual_allowance_exceeded_with_previous_years(calc_pension_contributions)], :amount, [:indent])
    end

    result[:elements] = [name, elements]
    if @data.year >= 2017 && @data.sco_taxpayer?
      result[:non_savings_non_dividend_remaining_below_higher] = remaining_allocation(sco_emp_remaining, :higher)
      result[:non_savings_non_dividend_higher_income] = total_allocated([sco_emp_allocated], :higher)[0]

      result[:savings_dividend_remaining_below_higher] = remaining_allocation(sav_remaining, :higher)
      result[:savings_dividend_higher_income] = total_allocated([sav_allocated], :higher)[0]

      result[:tax] = sco_emp_allocated.values.map { |income, tax| tax }.sum + sav_allocated.values.map { |income, tax| tax }.sum
    else
      result[:remaining_below_higher] = remaining_allocation(sav_remaining, :higher)
      result[:higher_income] = total_allocated([emp_allocated, sav_allocated], :higher)[0]
      result[:tax] = emp_allocated.values.map { |income, tax| tax }.sum + sav_allocated.values.map { |income, tax| tax }.sum
    end
    result[:pension_annual_allowance_remaining] = pension_annual_allowance_remaining_with_previous_years(calc_pension_contributions)
    result
  end
end
