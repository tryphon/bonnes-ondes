class Radio < ActiveRecord::Base

  attr_accessible :name, :description, :slug

  has_one :host, :dependent => :destroy, :as => :site
  belongs_to :template

  liquid_methods :name, :description, :shows, :posts, :episodes

  has_and_belongs_to_many :users
  has_many :radio_shows, :order => "`slug` desc"
  has_many :shows, :through => :radio_shows, :order => "radio_shows.slug" do
    def find_by_slug(slug)
      proxy_association.owner.radio_shows.includes(:show).find_by_slug(slug).try(:show)
    end
  end
  has_many :posts, :through => :shows, :order => "`created_at` desc"
  has_many :episodes, :through => :shows, :order => "`broadcasted_at` desc"

  def parent
    nil
  end

end

class Radio::LiquidDropClass
  include Liquid::ViewSupport

  # def url_for
  #   view.url_for_show(@object)
  # end

  def show
    @radio_shows ||= RadioShows.new(@object)
  end

  def not_broadcasted_episodes
    Episode.sort(@object.episodes.not_broadcasted).reverse
  end

  def url_for
    view.radio_url(@object)
  end

  def tag
    @radio_tags ||= RadioTags.new(@object)
  end

end

class RadioShows < Liquid::Drop

  def initialize(radio)
    @radio = radio
  end

  def [](key)
    @radio.shows.find_by_slug(key)
  end

end

class RadioTags < Liquid::Drop

  def initialize(radio)
    @radio = radio
  end

  def [](key)
    Episode.sort @radio.episodes.find_tagged_with(key)
  end

end
