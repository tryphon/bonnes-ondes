# -*- coding: utf-8 -*-
module DatesHelper
  def format_date(date)
    format = 'le %d/%m/%Y'

    if date.today?
      format = 'à %H:%M'
    end
    if date == Date.yesterday
      format = 'hier à %H:%M'
    end

    date.strftime(format)
  end
end
