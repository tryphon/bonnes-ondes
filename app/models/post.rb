# -*- coding: utf-8 -*-
class Post < ActiveRecord::Base

  attr_accessible :slug, :description, :title

  belongs_to :show, :touch => true
  validates_presence_of :show_id, :title, :slug, :description

  validates_presence_of :title, :message => "Pas de titre défini"
  validates_presence_of :slug, :message => "Pas de lien défini"
  validates_presence_of :description, :message => "Pas de texte défini"

  @@slug_length = 40
  cattr_reader :slug_length

  validates_length_of :slug, :within => 3..slug_length, :wrong_length => "Le lien doit contenir entre 3 et #{slug_length} lettres"

  liquid_methods :show, :title, :description, :created_at

  scope :last_updated, :order => 'updated_at desc', :limit => 5

  def to_param
    slug or id
  end
end
# TODO move this f... code anywhere else
class Post::LiquidDropClass
  include Liquid::ViewSupport

  def url_for
    view.post_url(@object)
  end

  def publication_distance
    ((@object.created_at - Time.zone.now) / 1.minute).to_i
  end

  def publication_days
    ((@object.created_at - Time.zone.now) / 1.day).to_i
  end

end
