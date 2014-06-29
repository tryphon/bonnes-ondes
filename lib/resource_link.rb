class ResourceLink

  attr_reader :resource

  @@public_domain = "bonnes-ondes.fr"
  cattr_accessor :public_domain

  @@admin_domain = "bonnes-ondes.tryphon.eu"
  cattr_accessor :admin_domain

  def initialize(resource, options = {})
    @resource = resource
    options.each { |k,v| send "#{k}=", v }
  end

  def url(options = {})
    "http://#{hostname}#{path(options)}"
  end

  def path(options = {})
    path_for path_resources, options
  end

  class FakeShow

    attr_accessor :slug
    def initialize(slug)
      @slug = slug
    end

    def self.model_name
      ActiveModel::Name.new(Show)
    end

    def to_param
      slug
    end

  end

  attr_accessor :url_context
  def path_for(path_resources, options = {})
    return '' if path_resources.empty?

    path_resources.map! do |resource|
      resource.is_a?(RadioShow) ? FakeShow.new(resource.slug) : resource
    end
    url_context.polymorphic_path [ :public, *path_resources ], options
  end

  attr_accessor :current_radio
  def current_radio
    context_radio or @current_radio
  end

  def context_radio
    url_context.respond_to?(:current_radio) and url_context.current_radio
  end

  def with(url_context)
    self.url_context = url_context
    self
  end

  def hostname
    host_resource.host ? host_resource.host.name : slug_hostname
  end

  def slug_hostname
    "#{host_resource.slug}.#{public_domain}"
  end

  def radio_show(show)
    current_radio.radio_shows.find_by_show_id(show) if current_radio
  end

  def show_or_radio_show(resource)
    resource.is_a?(Show) && current_radio ? radio_show(resource) : resource
  end

  def parent_resource(resource)
    case resource
    when Content
      resource.episode
    when Page, Post, Episode
      show_or_radio_show resource.show
    when Show
      if associated_radio_show = radio_show(resource)
        parent_resource associated_radio_show
      end
    when RadioShow
      resource.radio
    when Radio
      nil
    end
  end

  def url_resources
    [ show_or_radio_show(resource) ].tap do |resources|
      while parent = parent_resource(resources.first)
        resources.unshift parent
      end
      if current_radio and resources.first != current_radio
        resources.unshift current_radio
      end
    end
  end

  def path_resources
    url_resources.dup.tap do |path_resources|
      path_resources.shift
    end
  end

  def host_resource
    url_resources.first
  end

  def self.host_resource(hostname)
    if slug = slug_in_hostname(hostname)
      Show.find_by_slug(slug) or Radio.find_by_slug(slug)
    else
      if host = Host.find_by_name(hostname)
        host.site
      end
    end
  end

  class RadioHost
    def self.matches?(request)
      ResourceLink.host_resource(request.host).is_a?(Radio)
    end
  end

  class ShowHost
    def self.matches?(request)
      ResourceLink.host_resource(request.host).is_a?(Show)
    end
  end

  class AdminHost
    def self.matches?(request)
      request.host == ResourceLink.admin_domain
    end
  end

  def self.radio_host?(hostname)
    host_resource(hostname).is_a?(Radio)
  end

  def self.show_host?(hostname)
    host_resource(hostname).is_a?(Show)
  end

  def self.slug_in_hostname(hostname)
    if hostname =~ /\A([^.]+).#{public_domain}\z/
      $1
    end
  end

end
