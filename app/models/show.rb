# -*- coding: utf-8 -*-
class Show < ActiveRecord::Base

  attr_accessible :name, :description, :slug, :host, :template_id, :audiobank_account, :logo_id

  has_one :host, :dependent => :destroy, :as => :site
  belongs_to :template

  liquid_methods :name, :description, :episodes, :logo, :tags, :posts, :pages, :slug

  def visit_count
    read_attribute(:visit_count) or 0
  end

  validates_presence_of :name, :message => "Pas de nom défini"
  validates_length_of :name, :within => 3..30, :too_short => "Le nom est trop court", :too_long => "Le nom est trop long"

  validates_presence_of :description, :message => "Pas de description définie"

  validates_presence_of :slug, :message => "Pas de lien défini"
  validates_length_of :slug, :within => 3..30, :wrong_length => "Le lien doit contenir entre 3 et 30 lettres"
  validates_format_of :slug, :with => /^[a-z0-9-]*$/, :message => "Le lien ne peut contenir que des minuscules, des chiffres et des tirets"

  validates_uniqueness_of :slug
  validates_exclusion_of :slug, :in => %w(www ftp assets0 assets1 assets2 assets3), :message => "Ce lien '%s' n'est pas disponible"

  has_and_belongs_to_many :users
1
  has_many :episodes, :dependent => :destroy, :order => "`order` desc"
  has_many :contents, :through => :episodes
  has_many :images, :dependent => :destroy
  has_many :posts, :dependent => :destroy, :order => "`created_at` desc"
  has_many :pages, :dependent => :destroy, :order => "position"

  has_many :radio_shows
  has_many :radios, :through => :radio_shows
  after_touch { |show| show.radios.each(&:touch) }

  belongs_to :audiobank_project

  def audiobank_account
    audiobank_project.try(:token)
  end

  def audiobank_account=(token)
    if audiobank_project
      if token.present?
        audiobank_project.update_attributes :token => token
      else
        audiobank_project.destroy
      end
    else
      create_audiobank_project :token => token
    end
  end

  def audiobank_enabled?
    audiobank_project.present?
  end

  belongs_to :logo, :class_name => "Image", :foreign_key => "logo_id"

  def next_episode_order
    current = episodes.inject(0) { |max, episode|
      (not episode.order.nil? and episode.order > max) ? episode.order : max
    }
    current + 1
  end

  def tags
    tag_counts = episodes.collect(&:tags).flatten.inject({}) do |counts, tag|
      counts[tag] = (counts[tag] or 0) + 1
      counts
    end

    tag_counts.sort { |a, b| b[1]<=>a[1] }.collect { |tag, count| tag }
  end

  def last_update_at
    (self.episodes + [ self ]).compact.collect(&:updated_at).compact.max
  end

  alias :real_template :template
  def template
    real_template or default_template
  end

  def default_template
    @default_template ||= (Template.find_by_slug(self.slug) or Show.default_template)
  end

  def self.default_template
    Template.default
  end

  def category
    # FIXME
    "News & Politics"
  end

  def contact_email
    "bonnes-ondes+#{id}@tryphon.eu"
  end

  def to_param
    slug
  end

  def destroyable?
    episodes.empty?
  end

end

# TODO move this f... code anywhere else
class Show::LiquidDropClass
  include Liquid::ViewSupport

  def broadcasted_episodes
    Episode.sort @object.episodes.broadcasted
  end

  def not_broadcasted_episodes
    Episode.sort(@object.episodes.not_broadcasted).reverse
  end

  def episodes
    Episode.sort(@object.episodes)
  end

  def popular_episodes
    @object.episodes.order('rating_avg desc, rating_count desc')
  end

  def tag
    @show_tags ||= ShowTags.new(@object)
  end

  def url_for
    view.show_url(@object)
  end

  def url_for_podcast
    view.podcast_show_url(@object)
  end

  def clippy_for_podcast
    view.clippy url_for_podcast
  end

  def itpc_url_for_podcast
    url_for_podcast.gsub(/^http:/, "itpc:")
  end

  def page
    @show_pages ||= ShowPages.new(@object)
  end

end

class ShowTags < Liquid::Drop

  def initialize(show)
    @show = show
  end

  def [](key)
    Episode.sort @show.episodes.find_tagged_with(key)
  end

end

class ShowPages < Liquid::Drop

  def initialize(show)
    @show = show
  end

  def [](key)
    @show.pages.find_by_slug(key)
  end

end
