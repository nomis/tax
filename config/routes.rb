# SPDX-FileCopyrightText: 2021 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

Rails.application.routes.draw do
  root "tax#index"

  resources :gb_tax_years, constraints: { format: ["html"] }
end
