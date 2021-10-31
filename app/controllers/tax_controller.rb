# SPDX-FileCopyrightText: 2021 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

class TaxController < ApplicationController
  def index
    @gb_years = GBTaxYear.all.order(year: :desc)
  end
end
