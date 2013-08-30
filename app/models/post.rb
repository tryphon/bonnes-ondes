# -*- coding: undecided -*-
class Post < ActiveRecord::Base
  belongs_to :show
  validates_presence_of :show_id, :title, :slug, :description

  validates_presence_of :title, :message => "Pas de titre défini"
  validates_presence_of :slug, :message => "Pas de lien défini"
  validates_presence_of :description, :message => "Pas de texte défini"

  @@slug_length = 40
  cattr_reader :slug_length

  validates_length_of :slug, :within => 3..slug_length, :wrong_length => "Le lien doit contenir entre 3 et #{slug_length} lettres"

  liquid_methods :show, :title, :description, :created_at

  named_scope :last_updated, :order => 'updated_at desc', :limit => 5

  def to_param
    slug
  end
end
# TODO move this f... code anywhere else
class Post::LiquidDropClass

  def url_for
    view.post_url(@object)
  end

end
