# -*- coding: utf-8 -*-
module ContentHelper

  def audio_player(content, options = {})
    return "" unless content

    additional_class = " ui360-vis" if options[:larg]
    
    content_tag(:div, :class => "ui360#{additional_class}") do
      content_tag :a, "#{content.name} <span class='duration'>(durée #{content.duration} min.)</span>", :title => "Ecouter #{content.name}", :href => content.content_url(:format => :mp3)
    end
  end

end
