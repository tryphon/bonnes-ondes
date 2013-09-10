# -*- coding: utf-8 -*-
require 'acts_as_list'
class Page < ActiveRecord::Base
  belongs_to :show
  validates_presence_of :show_id

  attr_accessible :slug, :title, :content

  @@slug_length = 40
  cattr_reader :slug_length

  validates_presence_of :slug, :message => "Pas de lien défini"
  validates_length_of :slug, :within => 3..slug_length, :wrong_length => "Le lien doit contenir entre 3 et #{slug_length} lettres"
  validates_format_of :slug, :with => /^[a-z0-9-]*$/, :message => "Le lien ne peut contenir que des minuscules, des chiffres et des tirets"
  validates_uniqueness_of :slug, :scope => :show_id, :message => "Une page utilise déjà ce lien"

  validates_presence_of :title, :message => "Pas de titre défini"
  validates_length_of :title, :within => 3..50, :too_short => "Le titre est trop court (minimum %d caractères)", :too_long => "Le titre est trop long (maximum %d caractères)"

  validates_presence_of :content, :message => "Pas de texte défini"

  acts_as_list :scope => :show
  liquid_methods :show, :title, :content

  def parent
    show
  end

  def to_param
    slug
  end
end

# TODO move this f... code anywhere else
class Page::LiquidDropClass
  include Liquid::ViewSupport

  def url_for
    view.page_url(@object)
  end

end
