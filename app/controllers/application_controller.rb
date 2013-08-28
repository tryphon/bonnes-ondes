# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotification::Notifiable

  helper :all
  helper_method :admin_show_path

  layout "default"

  helper_method :user_session

  def content_playlist(content)
    if content.respond_to? "playlist_url"
      redirect_to content.playlist_url
    else
      render :text => content.content_url, :content_type => "audio/x-mpegurl"
    end
  end

  protected

  def user_session
    @user_session ||= UserSession.new(session)
  end

  def site_object(object)
    parents_object(object).first or object
  end
  helper_method :site_object

  def parent_object(object)
    if object.is_a?(Show)
      # FIXME Force Radio site for the moment
      object.radios.present? ? object.radios.first : nil
    else
      object.parent
    end
  end
  helper_method :parent_object

  def parents_object(object)
    [].tap do |parents|
      while parent = parent_object(object)
        parents.unshift parent
        object = parent
      end
    end
  end
  helper_method :parents_object

end
