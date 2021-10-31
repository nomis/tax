module GBTaxYearsHelper
  def fmt_amount(value)
    "£" + number_with_precision(value, precision: 2, delimiter: ",")
  end

  def fmt_date(value)
    if value.respond_to?(:day)
      "%04d-%02d-%02d" % [year.to_i, value.month, value.day]
    else
      "%04d-%02d" % [year.to_i, value.month]
    end
  end
end
