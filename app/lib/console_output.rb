# SPDX-FileCopyrightText: 2021 Simon Arlott
# SPDX-License-Identifier: AGPL-3.0-or-later
# frozen_string_literal: true

module ConsoleOutput
  def self.output_sections(sections)
    sections.each do |name, elements|
      output_section(name, elements)
    end
  end

  def self.output_section(name, elements)
    puts ANSI::Code.underline { name }
    output_elements(elements)
  end

  def self.output_elements(elements)
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
      printf "%-50s", name

      values.each do |value|
        if element[:markers].include? :headings
          print " " * [1, 16 - value.length].max
          print ANSI::Code.underline { colour + value }
        else
          printf " %15s", value
        end
      end

      print ANSI::Code.clear
      puts
    end
    puts
  end
end
