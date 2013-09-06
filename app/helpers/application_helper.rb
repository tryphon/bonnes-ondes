# -*- coding: utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include RateHelper
  include UserVoiceHelper

  def main_domain
    RAILS_ENV == 'development' ? 'bonnes-ondes.local' : 'bonnes-ondes.fr'
  end

  def site_hostname(object)
    site = site_object(object)

    hostname = if site.host.nil? or site.host.name.nil?
      "#{site.slug}.#{main_domain}"
    else
      site.host.name
    end

    hostname + request.port_string
  end

  def url_for_radio(radio, options = {})
    url_for_object radio, options
  end

  def url_for_show(show, options = {})
    url_for_object show, :action => "show"
  end

  def url_for_podcast(show, options = {})
    url_for_object show, :action => "feed"
  end

  def url_for_page(page, options = {})
    url_for_object page, :action => "page", :page_slug => page.slug
  end

  def url_for_episode(episode, options = {})
    url_for_object episode, :action => "episode", :episode_slug => episode.slug
  end

  def url_for_vote(episode, options = {})
    options = options.merge(:action => "vote", :episode_id => episode.id)
    url_for_object episode, options
  end

  def url_for_content(content, options = {})
    mode = :content
    if options.is_a? Symbol
      mode = options
    else
      mode = options.delete(:mode) if options[:mode]
    end

    options = options.merge :action => mode, :content_slug => content.slug, :episode_slug => content.episode.slug
    url_for_object content, options
  end

  def url_for_show_tag(show, tag, options = {})
    url_for_object show, :action => "tags", :search => tag.name
  end

  def url_for_sitemap(site)
    url_for :controller => "sitemaps", :action => "show", :id => site.slug, :only_path => false
  end

  def link_to_show(show)
    link_to(h(show.name), url_for_show(show))
  end

  def link_to_episode(episode)
    link_to(h(episode.title), url_for_episode(episode))
  end

  def link_to_content(name, content, options = {})
    options = { :mode => options } if options.is_a? Symbol
    options[:mode] ||= :content

    html_options = {}
    if options[:popup]
      html_options[:popup] = ["bonnes-ondes-#{content.id}", 'height=300,width=800']
    end
    link_to(name, url_for_content(content, options), html_options)
  end

  def error_messages_for(object_name, options = {})
    options = options.symbolize_keys
    object = instance_variable_get("@#{object_name}")
    if object && !object.errors.empty?
      content_tag("div",
        content_tag(options[:header_tag] || "h2", "#{pluralize(object.errors.count, "erreur a été trouvé", "erreurs ont été trouvées")}") +
        content_tag("ul", object.errors.collect { |name, message| content_tag("li", link_to(message, "##{object_name}_#{name}")) }),
        "id" => options[:id] || "errors", "class" => options[:class] || "errors"
      )
    else
      ""
    end
  end


  def textilize_in_text(content)
    RedCloth.new(content).to_plain
  end

  private

  def url_for_object(object, options)
    base_options = { :host => site_hostname(object) }

    parents = parents_object(object)

    if parents.first.is_a?(Radio)
      show = object.is_a?(Show) ? object : parents.second
      base_options[:show_slug] = show.slug
    end

    options = options.merge(base_options).merge(:controller => "public")

    url_for options
  end

  # def object_slugs(object)
  #   ([object] + parents_object(object)).inject({}) do |slugs, parent|
  #     parent_type = parent.class.name.parameterize
  #     slugs["#{parent_type}_slug"] = parent
  #     slugs
  #   end
  # end

end
