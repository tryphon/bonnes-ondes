# -*- coding: utf-8 -*-
require 'net/http'

class Content < ActiveRecord::Base

  attr_accessible :name, :slug, :principal

  scope :principal, :conditions => { :principal => true }
  scope :for_feed, lambda { |show| {
      :conditions => [ "shows.id = ? and episodes.broadcasted_at < ? ", show.id, Time.now ],
      :include => { :episode => [:tags, :show, :contents] },
      :order => "episodes.broadcasted_at desc"
    }
  }

  liquid_methods :name, :episode, :duration, :has_duration?, :id, :available?, :principal

  validates_presence_of :name, :message => "Pas de nom défini"
  validates_length_of :name, :within => 3..40, :too_short => "Le nom est trop court", :too_long => "Le nom est trop long"

  validates_presence_of :slug, :message => "Pas de lien défini"
  validates_length_of :slug, :within => 3..30, :wrong_length => "Le lien doit contenir entre 3 et 20 lettres"
  validates_format_of :slug, :with => /^[a-z0-9-]*$/, :message => "Le lien ne peut contenir que des minuscules, des chiffres et des tirets"
  validates_uniqueness_of :slug, :scope => :episode_id, :message => "Un contenu utilise déjà ce lien"

  belongs_to :episode, :touch => true
  # FIXME no way to build Factory(:content) with this validation
  # validates_presence_of :episode_id

  def self.build(content_type, attributes)
    Object.const_get("#{content_type.to_s.capitalize}Content").new(attributes)
  end

  def has_duration?
    not duration.nil? and duration > 0
  end

  def available?
    available_end_at.nil? or available_end_at.future?
  end

  def ready?
    true
  end

  # def self.model_name
  #   @model_name ||= ActiveModel::Name.new(Content)
  # end

  def length
    # FIXME we need to save two lengths, for ogg and mp3 formats
    duration and duration * 700000
  end

  def validate_content_type(content_types)
    return false if content_url.blank?

    content_types = Array(content_types)

    begin
      response = http_request_head content_url
      logger.debug "Content-Type: #{response['content-type']} for #{content_url}"
      content_types.include? response['content-type']
    rescue Net::HTTPServerException => e
      logger.warn("Can't validate content type for #{content_url}: #{e}")
      false
    end
  end

  def parent
    episode
  end

  def to_param
    slug
  end

  private

  def http_request_head(uri_str, limit = 10)
    # You should choose better exception.
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    url = URI.parse(uri_str)
    response = Net::HTTP.start(url.host, url.port) {|http|
      http.request_head(url.path)
    }

    case response
      when Net::HTTPSuccess then
        response
      when Net::HTTPRedirection then
        http_request_head response['location'], limit - 1
      else
        response.error!
    end
  end

end

class TestContent < Content

  def content_url(options = {})
    "dummy"
  end

end

# TODO move this f... code anywhere else
class Content::LiquidDropClass
  include Liquid::ViewSupport

  def url_for
    view.content_url(@object)
  end

  def url_for_playlist
    view.content_url(@object, :format => :m3u)
  end

  def url_for_mp3
    @object.content_url(:format => :mp3)
  end

  def url_for_ogg
    @object.content_url(:format => :ogg)
  end

  def embedded_player
    view.tag(:embed,
      :src => "/flash/mediaplayer.swf", :type => "application/x-shockwave-flash",
      :pluginspage => "http://www.macromedia.com/go/getflashplayer", :height => "20", :width => "370",
      :flashvars => "file=#{@object.content_url(:format => :mp3)}")
  end

  def embedded_player_started
    view.tag(:embed,
      :src => "/flash/mediaplayer.swf", :type => "application/x-shockwave-flash",
      :pluginspage => "http://www.macromedia.com/go/getflashplayer", :height => "20", :width => "370",
      :flashvars => "file=#{@object.content_url(:format => :mp3)}&autostart=true")
  end

  def audio_player
    view.audio_player(@object)
  end

  def large_audio_player
    view.audio_player(@object, :size => :large)
  end
  alias_method :larg_audio_player, :large_audio_player

end
