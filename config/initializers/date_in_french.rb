# -*- coding: utf-8 -*-
# French month names
require 'date'

silence_warnings do
  Date.const_set "MONTHNAMES_EN", Date::MONTHNAMES
  Date.const_set "MONTHNAMES", [nil] + %w(janvier février mars avril mai juin juillet août septembre octobre novembre décembre)
  Date.const_set "DAYNAMES_EN", Date::DAYNAMES
  Date.const_set "DAYNAMES", %w(dimanche lundi mardi mercredi jeudi vendredi samedi)
  Date.const_set "ABBR_MONTHNAMES", [nil] + %w(jan fév mar avr mai juin juil aoû sep oct nov dec)
end

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
  :long => '%A %d %B %Y' # Lundi 21 Septembre 2007
)
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :time => '%Hh%M' # 18h11
)

class Time

  def strftime_local(format)
    formatted = strftime(format)

    if format.include? '%B'
      Date::MONTHNAMES_EN.each_with_index do |month_en, index|
        formatted = formatted.gsub(month_en, Date::MONTHNAMES[index]) unless month_en.nil?
      end
    end

    if format.include? '%A'
      Date::DAYNAMES_EN.each_with_index do |day_en, index|
        formatted = formatted.gsub(day_en, Date::DAYNAMES[index]) unless day_en.nil?
      end
    end

    formatted
  end

end
