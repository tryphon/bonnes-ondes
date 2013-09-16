module Liquid
  module AudioPlayerFilters
    include ViewSupport
    include DropSupport

    def audio_player(content, size = :large)
      content = resolve(content)
      view_context.audio_player content, :size => size
    end
  end
end
