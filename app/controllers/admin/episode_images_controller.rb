class Admin::EpisodeImagesController < AdminController
  defaults :singleton => true, :resource_class => Image, :instance_name => 'image'
  nested_belongs_to :show, :episode, :finder => :find_by_slug
end
