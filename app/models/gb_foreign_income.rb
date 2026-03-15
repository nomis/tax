# SPDX-FileCopyrightText: 2026 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

class GBForeignIncome < ApplicationRecord
  belongs_to :year, class_name: "GBTaxYear", inverse_of: :foreign_income

  validates :country, presence: true, length: { minimum: 2, maximum: 2, with: /\A[A-Z]+\z/ }
end
