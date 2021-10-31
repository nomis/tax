# SPDX-FileCopyrightText: 2021 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

namespace :tax do
  task :gb => :environment do
    GBTaxYear.pluck(:year).each do |year|
      task year.to_s => :environment do
        puts GBTaxYear.find_by(year: year.to_i).name
        puts

        calc = GBTaxCalculation.new(year.to_i)

        ConsoleOutput::output_elements(calc.inputs)
        ConsoleOutput::output_sections(calc.calculations)
        ConsoleOutput::output_sections(calc.outputs)
      end
    end
  end
end
