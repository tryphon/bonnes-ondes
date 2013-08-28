class Post < ActiveRecord::Base
  belongs_to :show
  validates_presence_of :show_id, :title, :slug, :description

  @@slug_length = 40
  cattr_reader :slug_length

  validates_length_of :slug, :within => 3..slug_length, :wrong_length => "Le lien doit contenir entre 3 et #{slug_length} lettres"

  liquid_methods :title, :description, :created_at

  named_scope :last_updated, :order => 'updated_at desc', :limit => 5
end
# TODO move this f... code anywhere else
class Post::LiquidDropClass

  def url_for
    view.url_for(@object)
  end

end
