# -*- coding: utf-8 -*-
class PublicController < ApplicationController

  layout false

  before_filter :check_current_site
  before_filter :push_host_google_analytics

  protected

  def user_session
    @user_session ||= UserSession.new(session)
  end
  helper_method :user_session

  def current_theme
    @theme ||= current_site.template
  end

  def render_template(template_name, assigns = {})
    theme_template = current_theme.template(template_name)
    if theme_template.exists?
      cache_reference =  [:template, template_name, current_site, :path, request.path.gsub(%r{^/}, '') ]
      Rails.logger.info "Cache reference #{ActiveSupport::Cache.expand_cache_key(cache_reference)}"
      rendered_template = cache(cache_reference) do
        theme_template.render(view_context, default_assigns.merge(assigns))
      end

      render :text => rendered_template
    else
      render_not_found
    end
  end

  def default_assigns
    { :template => current_theme }.tap do |assigns|
      assigns[:show] = current_show if current_show
      assigns[:radio] = current_radio if current_radio
    end
  end

  def check_current_site
    render_not_found unless current_site
  end

  def check_current_show
    render_not_found unless current_show
  end

  def render_not_found
    render :file => Rails.root + "public/404.html", :status => "404" # , :layout => false
  end

  def current_site
    @site ||= ResourceLink.host_resource(request.host)
  end
  helper_method :current_site

  def current_show
    @show ||=
      begin
        if current_radio
          current_radio.shows.find_by_slug(params[:show_id])
        else
          current_site if current_site.is_a?(Show)
        end
      end
  end
  helper_method :current_show

  def current_radio
    @radio ||= current_site if current_site.is_a?(Radio)
  end
  helper_method :current_radio

  def resource_link(resource)
    super.tap do |link|
      link.current_radio = current_radio
    end
  end

  def push_host_google_analytics
    # FIXME requires Rails 3.x
    # ga_push("_addItem", "ID", "SKU")
  end

end
