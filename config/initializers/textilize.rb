require 'red_cloth_formatters_plain'

module RedCloth
  module Formatters
    module Plain

      # render link name followed by (url)
      def link(opts)
        name = opts[:name]
        url = opts[:href]

        # Remove mailto: prefix
        if url =~ /^mailto:(.*)$/
          url = $1
        end

        if name != url
          "#{name} (#{url})"
        else
          name
        end
      end

    end
  end
end
