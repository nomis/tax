class GBIncomeMonth < ApplicationRecord
  belongs_to :year, class_name: "GBTaxYear", inverse_of: :income_months
  belongs_to :company

  def total_income
    basic + bonus + arrears + overtime + extra
  end
end
