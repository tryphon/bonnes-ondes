class Image < ActiveRecord::Base

  attr_accessible :title, :content

  liquid_methods :width, :height, :title

  belongs_to :show, :touch => true

  image_accessor :content

  validates_presence_of :content
  validates_size_of :content, :maximum => 5.megabytes
  validates_property :format, of: :content, in: [:jpg, :png, :gif], case_sensitive: false

  @@default_geometry = "200x200>"
  cattr_accessor :default_geometry

  def admin_preview_url
    content.thumb("200x200>").url
  end

  def admin_thumb_url
    content.thumb("75x75").url
  end

  protected

  def attachment_attributes_valid?
    if self.size and self.size > attachment_options[:max_size]
      errors.add :size, "Le fichier de l'image est trop grand (5Mo maximum)"
    elsif not attachment_options[:content_type].include? self.content_type
      errors.add :size, "Le fichier n'est pas reconnu comme une image (#{content_type})"
    else
      super
    end
  end

end

class Image::LiquidDropClass
  include Liquid::ViewSupport

  def url_for
    @object.content.thumb('200x200>').url
  end

  def url_for_thumb
    @object.content.thumb('75x75').url
  end

  def url_for_larg
    @object.content.thumb('500x500>').url
  end

  def tag
    view.image_tag url_for, :title => @object.title
  end

  def tag_for_thumb
    view.image_tag url_for_thumb, :title => @object.title
  end

  def tag_for_larg
    view.image_tag url_for_larg, :title => @object.title
  end
end
