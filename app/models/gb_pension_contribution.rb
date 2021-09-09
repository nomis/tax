# SPDX-FileCopyrightText: 2021 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

class GBPensionContribution < ApplicationRecord
  belongs_to :year, class_name: "GBTaxYear", inverse_of: :pension_contributions
end
