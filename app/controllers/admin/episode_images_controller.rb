class Admin::EpisodeImagesController < AdminController
  defaults :singleton => true, :resource_class => Image, :instance_name => 'image'
  nested_belongs_to :show, :episode, :finder => :find_by_slug

  def edit
    @images ||= parent.show.images.order("created_at desc")
    edit!
  end
end
