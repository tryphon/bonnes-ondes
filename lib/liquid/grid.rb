module Liquid
  class Grid < Block
    Syntax = /(\w+)\s+in\s+(#{QuotedFragment}+)\s*(reversed)?/o

    def initialize(tag_name, markup, options)
      super
      if markup =~ Syntax
        @variable_name = $1
        @collection_name = $2
        @reversed = $3
        @attributes = {}
        markup.scan(TagAttributes) do |key, value|
          @attributes[key] = value
        end
      else
        raise SyntaxError.new(options[:locale].t("errors.syntax.grid".freeze))
      end
    end

    def render(context)
      collection = context[@collection_name] or return ''.freeze

      from = @attributes['offset'.freeze] ? context[@attributes['offset'.freeze]].to_i : 0
      to = @attributes['limit'.freeze] ? from + context[@attributes['limit'.freeze]].to_i : nil

      collection = Utils.slice_collection(collection, from, to)
      collection.reverse! if @reversed

      length = collection.length

      cols = context[@attributes['cols'.freeze]].to_i

      row = 1
      col = 0

      grid = [[]]

      context.stack do

        collection.each_with_index do |item, index|
          context[@variable_name] = item
          context['gridloop'.freeze] = {
            'length'.freeze    => length,
            'index'.freeze     => index + 1,
            'index0'.freeze    => index,
            'col'.freeze       => col + 1,
            'col0'.freeze      => col,
            'index0'.freeze    => index,
            'rindex'.freeze    => length - index,
            'rindex0'.freeze   => length - index - 1,
            'first'.freeze     => (index == 0),
            'last'.freeze      => (index == length - 1),
            'col_first'.freeze => (col == 0),
            'col_last'.freeze  => (col == cols - 1)
          }


          col += 1

          grid[row-1] << render_all(@nodelist, context)

          if col == cols and (index != length - 1)
            col  = 0
            row += 1
            grid << []
          end

        end
      end

      # direction = @attributes['direction'] ? context[@attributes['direction']] : 'vertical'

      # if direction == 'vertical'
        (cols - col).times { grid[row-1] << "" }
        grid.transpose
      # end

      grid.map do |items|
        %Q{<div class="column">#{items.join("\n")}</div>}
      end.join("\n")
    end
  end

  # Template.register_tag('grid'.freeze, Grid)
end
