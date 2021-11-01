# SPDX-FileCopyrightText: 2021 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

module ConsoleOutput
  def self.output_sections(sections, options = {})
    options = options.merge(max_width_sections(sections))
    sections.each do |name, elements|
      output_section(name, elements, options)
    end
  end

  def self.max_width_sections(sections)
    name_width = 1
    value_width = 1
    sections.each do |name, elements|
      elements.each do |element|
        name_width = [name_width, element[:name].length].max if element[:name].present?
        element[:values].each do |value|
          value_width = [value_width, value.length].max if value.present?
        end
      end
    end
    {name_width: name_width + 2, value_width: value_width + 2}
  end

  def self.output_section(name, elements, options = {})
    puts ANSI::Code.underline { name } if name.present?
    output_elements(elements, options)
  end

  def self.output_elements(elements, options = {})
    elements.each do |element|
      name = element[:name]
      values = element[:values]

      if element[:markers].include? :indent
        name = "  " + name
      end

      colour = ""
      if element[:markers].include? :discarded
        colour = ANSI::Code.white
      elsif element[:markers].include? :higher
        colour = ANSI::Code.red
      elsif element[:markers].include? :comparable
        colour = ANSI::Code.yellow
      end

      print colour
      printf "%-*s", options.fetch(:name_width, 50), name

      values.each do |value|
        if element[:markers].include? :headings
          print " " * [1, options.fetch(:value_width, 15) - value.length + 1].max
          print ANSI::Code.underline { colour + value }
        else
          printf " %*s", options.fetch(:value_width, 15), value
        end
      end

      print ANSI::Code.clear
      puts
    end
    puts
  end
end
