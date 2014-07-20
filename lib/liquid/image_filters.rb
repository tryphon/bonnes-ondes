module Liquid
  module ImageFilters
    include ViewSupport
    include DropSupport

    def image_url(image, geometry = Image.default_geometry)
      image = resolve(image)
      image.content.thumb(geometry).url if image
    end

    def image_tag(image, geometry = Image.default_geometry)
      image = resolve(image)
      view_context.image_tag image_url(image, geometry), :alt => image.title if image
    end
  end
end
