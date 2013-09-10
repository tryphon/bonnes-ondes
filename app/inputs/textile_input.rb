class TextileInput < SimpleForm::Inputs::Base
  def input
    @builder.textile_area(attribute_name, :disable => :image)
  end
end
