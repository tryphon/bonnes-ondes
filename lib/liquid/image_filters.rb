module Liquid
  module ImageFilters
    include ViewSupport
    include DropSupport

    def image_url(image, geometry = Image.default_geometry)
      image = resolve(image)
      image.content.thumb(geometry).url
    end

    def image_tag(image, geometry = Image.default_geometry)
      image = resolve(image)
      view_context.image_tag image_url(image, geometry), :alt => image.title
    end
  end
end
