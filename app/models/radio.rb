class Radio < ActiveRecord::Base
  has_one :host, :dependent => :destroy, :as => :site
  belongs_to :template

  liquid_methods :name, :description, :shows

  has_and_belongs_to_many :users
  has_and_belongs_to_many :shows

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

end

class RadioShows < Liquid::Drop

  def initialize(radio)
    @radio = radio
  end

  def [](key)
    @radio.shows.find_by_slug(key)
  end

end
