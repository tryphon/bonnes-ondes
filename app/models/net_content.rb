# -*- coding: utf-8 -*-
class NetContent < Content

  validates_presence_of :url, :message => "Pas d'adresse définie"

  def content_url(options = {})
    url
  end

  def support_format?(format)
    [ :mp3 ].include? format
  end

  def validate
    unless validate_content_type %w{ audio/mpeg application/ogg audio/ogg }
      errors.add_to_base("Ce document n'est pas trouvable")
    end
  end

end
