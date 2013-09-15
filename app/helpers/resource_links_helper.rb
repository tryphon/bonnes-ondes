module ResourceLinksHelper

  def self.included(base)
    %w{audiobank net}.each do |content_type|
      base.class_eval <<-EOM
         def public_episode_#{content_type}_content_path(*arguments)
           public_episode_content_path *arguments
         end
         def public_show_episode_#{content_type}_content_path(*arguments)
           public_show_episode_content_path *arguments
         end
       EOM
    end

    %w{radio show episode content page post content}.each do |resource_name|
      base.class_eval <<-EOM
        def #{resource_name}_url(resource, options = {})
          resource_link(resource).url(options)
        end

        def #{resource_name}_path(resource, options = {})
          resource_link(resource).path(options)
        end
      EOM
    end
  end

  def public_episode_audiobank_content_path(*arguments)
    public_episode_content_path *arguments
  end
  def public_episode_net_content_path(*arguments)
    public_episode_content_path *arguments
  end

  def site_url(site)
    site.is_a?(Radio) ? radio_url(site) : show_url(site)
  end

  def podcast_show_url(show)
    # FIXME
    "#{show_url(show).gsub(%r{/$},'')}/feed"
  end

  def sitemap_url(site)
    "#{site_url(site)}/sitemap.xml"
  end

  def show_tag_url(show, tag)
    # FIXME
    "#{show_url(show).gsub(%r{/$},'')}/tags/#{tag}"
  end

  def episode_vote_path(episode, arguments = {})
    # FIXME
    query = "?" + arguments.map { |k,v| "#{k}=#{v}" }.join('&') if arguments.present?
    "#{episode_path(episode)}/vote#{query}"
  end

  protected

  def resource_link(resource)
    ResourceLink.new(resource).with(self)
  end

end
