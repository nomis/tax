# SPDX-FileCopyrightText: 2021-2022 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

module GBFormat
  extend ActionView::Helpers::NumberHelper

  def self.element(name = nil, values = [], formats = nil, markers = [])
    if !values.is_a? Array
      values = [values]
    end

    if !formats.is_a? Array
      formats = [formats] * values.size
    end

    values = values.each_with_index.map do |value, index|
      if value.nil?
        ""
      else
        case formats[index]
        when :amount
          "£" + self.number_with_precision(value, precision: 2, delimiter: ",")
        when :percent
          number_with_precision(value, precision: 2) + "%"
        else
          value
        end
      end
    end

    {
      name: name,
      values: values,
      markers: markers
    }
  end
end
