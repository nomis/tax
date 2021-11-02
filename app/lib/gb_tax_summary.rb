# SPDX-FileCopyrightText: 2021 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

class GBTaxSummary
  def initialize(year)
    @data = GBTaxYear.find_by(year: year)
    @calc = GBTaxCalculation.new(year.to_i)
    @run = false
  end

  def outputs
    run
    @outputs
  end

  def companies
    @companies ||= @data.income_months.sort(&GBSortDates).map(&:company).uniq
  end

  private

  def run
    return if @run
    @run ||= true

    @outputs = []

    outputs << ["Employment Income",
      companies.map do |company|
        element(company.name, @data.income_months.select { |im| im.company == company }.sum(&:total_income), :amount)
      end + (companies.length > 1 ? [element("Total", @data.total_income, :amount)] : [])
    ]

    outputs << ["Savings Income",
      [
        element("Gross Interest", @data.gross_interest, :amount),
        element("Net Interest", @data.net_interest, :amount),
      ]
    ]

    outputs << ["Tax Relief",
      [
        element("Gift Aid (Net)", @data.net_gift_aid, :amount),
        element("Allowable Expenses", @data.allowable_expenses.ceil, :amount),
      ]
    ]

    outputs << ["Employee Pension Contributions (Net)",
      companies.map do |company|
        element(company.name, @data.income_months.select { |im| im.company == company }.sum(&:net_pension), :amount)
      end + [
        element("SIPP (Target)", @calc.target_sipp_net_pension_contributions, :amount),
        element("Total", @data.paye_net_pension_contributions + @calc.target_sipp_net_pension_contributions, :amount),
      ]
    ]

    outputs << ["Employer Pension Contributions",
      companies.map do |company|
        element(company.name, @data.income_months.select { |im| im.company == company }.sum(&:employer_pension), :amount)
      end + (companies.length > 1 ? [element("Total", @data.total_employer_pension_contributions, :amount)] : [])
    ]

    outputs << ["PAYE",
      [
        element("Best Tax Code", @calc.best_paye_tax_code),
      ]
    ]

  end

  define_method :element, &GBFormat.singleton_method(:element)
end
