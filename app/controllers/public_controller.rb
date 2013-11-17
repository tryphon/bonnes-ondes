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
        post_process theme_template.render(view_context, default_assigns.merge(assigns))
      end

      render :text => rendered_template
    else
      render_not_found
    end
  end

  def post_process(content)
    if current_host.try(:google_analytics_tracker_id)
      html_document = Nokogiri::HTML::Document.parse content

      google_html = <<-EOF
        <script type="text/javascript">
          var _gaq = _gaq || [];
          _gaq.push(['_setAccount', '#{current_host.google_analytics_tracker_id}']);
          _gaq.push(['_trackPageview']);

          (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          })();
        </script>
      EOF

      head = html_document.at_css "head"
      if head
        head.add_child google_html
      end

      html_document.to_html
    else
      content
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

  def current_host
    @host ||= current_site.host
  end

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
    # _paq.push(['setDocumentTitle', document.domain + "/" + document.]);
  end

end
