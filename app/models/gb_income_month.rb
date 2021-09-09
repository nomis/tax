# SPDX-FileCopyrightText: 2021 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

class GBIncomeMonth < ApplicationRecord
  belongs_to :year, class_name: "GBTaxYear", inverse_of: :income_months
  belongs_to :company

  def total_income
    basic + bonus + arrears + overtime + extra
  end
end
