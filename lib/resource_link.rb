class ResourceLink

  attr_reader :resource

  @@public_domain = "bonnes-ondes.fr"
  cattr_accessor :public_domain

  @@admin_domain = "bonnes-ondes.tryphon.eu"
  cattr_accessor :admin_domain

  def initialize(resource)
    @resource = resource
  end

  def url(options = {})
    "http://#{hostname}#{path(options)}"
  end

  def path(options = {})
    path_for path_resources, options
  end

  attr_accessor :url_context
  def path_for(path_resources, options = {})
    return '' if path_resources.empty?

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

  def parent_resource(resource)
    case resource
    when Content
      resource.episode
    when Page, Post, Episode
      resource.show
    when Radio, Show
      nil
    end
  end

  def url_resources
    [ resource ].tap do |resources|
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
