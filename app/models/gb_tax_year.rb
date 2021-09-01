class GBTaxYear < ApplicationRecord
  has_many :income_months, class_name: "GBIncomeMonth", foreign_key: "year_id", inverse_of: :year
  has_many :pension_contributions, class_name: "GBPensionContribution", foreign_key: "year_id", inverse_of: :year

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

  def total_employer_pension_contributions
    income_months.sum(&:employer_pension)
  end

  def total_paye_paid
    income_months.sum(&:paye_paid)
  end
end
