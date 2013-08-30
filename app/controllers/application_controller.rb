# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotification::Notifiable

  helper :all

  layout "default"

  # helper_method :user_session

  protected

  def resource_link(resource)
    ResourceLink.new(resource).with(self)
  end

  %w{radio show episode content page post content}.each do |resource_name|
    eval <<-EOM
      def #{resource_name}_url(resource, options = {})
        resource_link(resource).url(options)
      end
    EOM
    helper_method "#{resource_name}_url"

    eval <<-EOM
      def #{resource_name}_path(resource, options = {})
        resource_link(resource).path(options)
      end
    EOM
    helper_method "#{resource_name}_path"
  end

  def site_url(site)
    site.is_a?(Radio) ? radio_url(site) : show_url(site)
  end

  def podcast_show_url(show)
    # FIXME
    "#{show_url(show)}feed"
  end
  helper_method :podcast_show_url

  def sitemap_url(site)
    "#{site_url(site)}sitemap.xml"
  end
  helper_method :sitemap_url

  def show_tag_url(show, tag)
    # FIXME
    "#{show_url(show)}tags/#{tag}"
  end
  helper_method :show_tag_url

  # def content_playlist(content)
  #   if content.respond_to? "playlist_url"
  #     redirect_to content.playlist_url
  #   else
  #     render :text => content.content_url, :content_type => "audio/x-mpegurl"
  #   end
  # end

  # def user_session
  #   @user_session ||= UserSession.new(session)
  # end

  # def site_object(object)
  #   parents_object(object).first or object
  # end
  # helper_method :site_object

  # def parent_object(object)
  #   if object.is_a?(Show)
  #     # FIXME Force Radio site for the moment
  #     object.radios.present? ? object.radios.first : nil
  #   else
  #     object.parent
  #   end
  # end
  # helper_method :parent_object

  # def parents_object(object)
  #   [].tap do |parents|
  #     while parent = parent_object(object)
  #       parents.unshift parent
  #       object = parent
  #     end
  #   end
  # end
  # helper_method :parents_object

end
