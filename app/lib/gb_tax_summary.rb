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
        element(nil, ["Gross", "Net"], nil, [:headings]),
        element("Interest (Gross)", [@data.gross_interest, @calc.net_interest_for_gross(@data.gross_interest)], :amount),
        element("Interest (Net)", [@calc.gross_interest_for_net(@data.net_interest), @data.net_interest], :amount),
        element("Total", [
          @data.gross_interest + @calc.gross_interest_for_net(@data.net_interest),
          @data.net_interest + @calc.net_interest_for_gross(@data.gross_interest)
        ], :amount),
      ]
    ]

    outputs << ["Tax Relief",
      [
        element(nil, ["Gross", "Net"], nil, [:headings]),
        element("Gift Aid", [@calc.gross_gift_aid, @data.net_gift_aid], :amount),
        element("Allowable Expenses", @data.allowable_expenses, :amount),
      ]
    ]

    outputs << ["Employee Pension Contributions",
      [
        element(nil, ["Gross", "Net"], nil, [:headings])
      ] + companies.map do |company|
        net_pension = @data.income_months.select { |im| im.company == company }.sum(&:net_pension)
        element(company.name, [@calc.gross_pension_contributions_for_net(net_pension), net_pension], :amount)
      end + [
        element("SIPP (Target)",
          [@calc.target_sipp_gross_pension_contributions,
            @calc.target_sipp_net_pension_contributions],
          :amount),
        element("Total (Target)",
          [@calc.paye_gross_pension_contributions + @calc.target_sipp_gross_pension_contributions,
            @data.paye_net_pension_contributions + @calc.target_sipp_net_pension_contributions],
          :amount),
      ]
    ]

    outputs << ["Employer Pension Contributions",
      companies.map do |company|
        element(company.name, @data.income_months.select { |im| im.company == company }.sum(&:employer_pension), :amount)
      end + (companies.length > 1 ? [element("Total", @data.total_employer_pension_contributions, :amount)] : [])
    ]

    outputs << ["PAYE",
      companies.map do |company|
        element(company.name, @data.income_months.select { |im| im.company == company }.sum(&:paye_paid), :amount)
      end + (companies.length > 1 ? [element("Total", @data.total_paye_paid, :amount)] : []) + [
        element,
        element("Best PAYE Tax Code", @calc.best_paye_tax_code),
      ]
    ]

  end

  define_method :element, &GBFormat.singleton_method(:element)
end
