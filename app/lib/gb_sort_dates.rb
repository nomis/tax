# SPDX-FileCopyrightText: 2021 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

module GBSortDates
  module_function

  def to_proc
    lambda(&method(:compare))
  end

  def compare(a, b)
    a_month = (a.month - 4) % 12
    b_month = (b.month - 4) % 12
    a_day = 0
    b_day = 0

    if a.respond_to?(:day) && b.respond_to?(:day)
      a_day = a.day
      b_day = b.day

      if a.month == 4 && a.day < 6
        a_month = 12
      end

      if b.month == 4 && b.day < 6
        b_month = 12
      end
    end

    if a_month == b_month
      a_day <=> b_day
    else
      a_month <=> b_month
    end
  end
end
