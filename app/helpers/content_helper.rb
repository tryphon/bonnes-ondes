# -*- coding: utf-8 -*-
module ContentHelper

  def audio_player(content, options = {})
    return "" unless content

    options[:size] = :larg if options.delete :larg

    options = {
      :size => :small
    }.merge(options)


    content_tag :div, :class => "player #{options[:size]}" do
      link_to content.content_url(:format => :mp3) do
        content_tag(:span, content.name, :class => "name") +
          content_tag(:span, "durée #{content.duration} min.", :class => "duration")
      end
    end
  end

end
