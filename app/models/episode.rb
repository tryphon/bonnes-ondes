# -*- coding: utf-8 -*-
class Episode < ActiveRecord::Base
  acts_as_taggable
  acts_as_rated

  named_scope :broadcasted, lambda { {:conditions => ["broadcasted_at < ?", Time.now] } }
  named_scope :not_broadcasted, lambda { {:conditions => ["broadcasted_at > ?", Time.now] } }

  liquid_methods :show, :slug, :title, :description, :image, :broadcasted_at, :tags, :rating_count, :rating_total, :rating_avg

  validates_presence_of :order, :message => "Pas de numéro défini"
  validates_uniqueness_of :order, :scope => :show_id, :message => "Un épisode utilise déjà ce numéro"

  validates_presence_of :title, :message => "Pas de titre défini"
  validates_length_of :title, :within => 3..60, :too_short => "Le titre est trop court (minimum %d caractères)", :too_long => "Le titre est trop long (maximum %d caractères)"

  validates_presence_of :description, :message => "Pas de description définie"

  @@slug_length = 40
  cattr_reader :slug_length

  validates_presence_of :slug, :message => "Pas de lien défini"
  validates_length_of :slug, :within => 3..slug_length, :wrong_length => "Le lien doit contenir entre 3 et #{slug_length} lettres"
  validates_format_of :slug, :with => /^[a-z0-9-]*$/, :message => "Le lien ne peut contenir que des minuscules, des chiffres et des tirets"
  validates_uniqueness_of :slug, :scope => :show_id, :message => "Un épisode utilise déjà ce lien"

  belongs_to :show
  # FIXME no way to build Factory(:episode) with this validation
  # validates_presence_of :show_id

  has_many :contents, :dependent => :destroy
  has_many :net_contents
  has_many :audiobank_contents

  belongs_to :image

  attr_accessor :audiobank_project

  def audiobank_project
    @audiobank_project ||= show.try(:audiobank_project)
  end

  def audiobank_enabled?
    audiobank_project.present?
  end

  attr_accessor :create_audiobank_document

  def create_audiobank_document?
    [true, "1"].include?(create_audiobank_document)
  end

  after_create :create_audiobank_content

  def create_audiobank_content
    AudiobankContent.create(:episode => self, :principal => true, :name => "Intégrale", :slug => "integrale", :create_document => true) if create_audiobank_document?
  end

  def broadcasted?
    if broadcasted_at
      broadcasted_at < Time.now
    else
      true
    end
  end

  def self.sort(episodes)
    if episodes.all?(&:broadcasted_at)
      episodes.sort_by(&:broadcasted_at).reverse
    else
      episodes
    end
  end

  def parent
    show
  end

end

# TODO move this f... code anywhere else
class Episode::LiquidDropClass

  def url_for
    view.url_for_episode(@object)
  end

  def contents
    @object.contents.select(&:ready?)
  end

  def principal_contents
    @object.contents.principal.select(&:ready?)
  end

  def html_description
    view.textilize(ContentFilter.new(@object).description_with_players(view))
  end

  def text_description
    view.textilize(ContentFilter.new(@object).description_without_players)
  end

  def vote_tag
    view.rate_tag(@object)
  end

  def tags
    @object.tag_list
  end

  def broadcast_distance
    ((@object.broadcasted_at - Time.now) / 1.minute).to_i
  end

  def broadcasted
    @object.broadcasted?
  end

end
