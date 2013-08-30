# -*- coding: utf-8 -*-
class PublicController < ApplicationController

  layout nil

  before_filter :check_current_site

  protected

  def current_theme
    @theme ||= current_site.template
  end

  def view_context
    @template
  end

  def render_template(template_name, assigns = {})
    render :text => current_theme.template(template_name).render(view_context, default_assigns.merge(assigns))
  end

  def default_assigns
    { "template" => current_theme }
  end

  def check_current_site
    unless current_site
      render :file => Rails.root + "public/404.html", :status => "404"
    end
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

end
