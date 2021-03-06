# -*- coding: utf-8 -*-

module TextFilter

  def textilize(input)
    RedCloth.new(input).to_html
  end

  def strip_tags(input)
    full_sanitizer.sanitize input
  end

  def integer(input)
    input.to_i
  end

  def pluralize(input, word)
    ActionView::Helpers::TextHelper::pluralize(input, word)
  end

  private

  def full_sanitizer
    @full_sanitizer ||= HTML::FullSanitizer.new
  end

end

Liquid::Template.register_filter(TextFilter)

module PrettyDateFilter

  def prettydate(input, format = nil)
    date =
      case input
      when String
        Time.parse(input)
      when Date, Time, DateTime
        input
      else
        return input
      end

    if format.blank?
      if date.today?
        format = 'aujourd\'hui à %Hh%M'
      elsif date == Date.yesterday
        format = 'hier à %Hh%M'
      elsif (Date.today - date.to_date).abs < 4
        format = '%A à %Hh%M'
      else
        format = 'le %d %B %Y à %Hh%M'
      end
    end

    I18n.localize date, :format => format.to_s
  end


end

Liquid::Template.register_filter(PrettyDateFilter)

class Liquid::Drop

  protected

  def view
    @context.registers[:view_context]
  end

end

Liquid::Template.register_filter Liquid::ImageFilters
Liquid::Template.register_filter Liquid::AudioPlayerFilters
Liquid::Template.register_tag('grid'.freeze, Liquid::Grid)
