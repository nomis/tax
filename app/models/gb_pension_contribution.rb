class GBPensionContribution < ApplicationRecord
  belongs_to :year, class_name: "GBTaxYear", inverse_of: :pension_contributions
end
