ActionController::Routing::Routes.draw do |map|

  map.with_options(:conditions => { :host => ResourceLink.admin_domain }) do |admin_host|
    admin_host.public '', :controller => "admin/welcome", :action => 'show'
    admin_host.admin 'compte', :controller => 'admin/dashboards', :action => 'show'

    admin_host.with_options(:path_prefix => "compte", :name_prefix => "admin_", :namespace => "admin/") do |admin|
      admin.resource :dashboard

      admin.activate 'activate/:code', :controller => 'account', :action => 'activate'

      admin.login 'login', :controller => 'account', :action => 'login'
      admin.logout 'logout', :controller => 'account', :action => 'logout'
      admin.signup 'signup', :controller => 'account', :action => 'signup'
      admin.recover_password 'recover_password', :controller => 'account', :action => 'recover_password'

      admin.resources :shows, :collection => { :slug => :post } do |shows|
        shows.resource :logo
        shows.resources :episodes, :collection => { :slug => :post } do |episodes|
          episodes.resource :image, :controller => "EpisodeImages"
          episodes.resources :contents
          episodes.resources :net_contents
          episodes.resources :audiobank_contents
        end
        shows.resources :posts, :collection => { :slug => :post }
        shows.resources :pages, :member => "move_up", :collection => { :slug => :post }
        shows.resources :images
      end

      admin.resources :templates
    end

    admin_host.resources :audiobank_updates
  end

  map.with_options(:name_prefix => "public_", :namespace => "public/") do |public|
    def show_routes(show)
      show.resources :episodes, :as => "ep" do |episodes|
        episodes.resources :contents, :as => "c"
        episodes.resource :vote
      end
      show.resources :pages, :as => "p"
      show.resources :posts
      show.resources :tags
      show.resource :feed
      show.resource :robots
      show.resource :sitemap
      show.resource :stream, :as => "direct"
    end

    public.with_options(:conditions => { :show_host => true }) do |show|
      show.connect '', :controller => "show", :action => "show"
      show_routes(show)
    end

    public.with_options(:conditions => { :radio_host => true }) do |radio|
      radio.connect '', :controller => "radio", :action => 'show'
      radio.resources :shows, :as => "e" do |shows|
        show_routes(shows)
      end
      radio.resource :robots
      radio.resource :sitemap
    end
  end

  # map.connect 'e/:show_slug', :controller => 'public', :action => 'show'

  # map.connect 'e/:show_slug/p/:page_slug', :controller => 'public', :action => 'page'
  # map.connect 'p/:page_slug', :controller => 'public', :action => 'page'

  # map.connect 'e/:show_slug/ep/:episode_slug', :controller => 'public', :action => 'episode'
  # map.connect 'ep/:episode_slug', :controller => 'public', :action => 'episode'

  # map.connect 'e/:show_slug/ep/:episode_slug/ecoute/:content_slug', :controller => 'public', :action => 'content'
  # map.connect 'ep/:episode_slug/ecoute/:content_slug', :controller => 'public', :action => 'content'

  # map.connect 'e/:show_slug/ep/:episode_slug/ecouter/:content_slug', :controller => 'public', :action => 'playlist'
  # map.connect 'ep/:episode_slug/ecouter/:content_slug', :controller => 'public', :action => 'playlist'

  # map.connect 'e/:show_slug/tags/:search', :controller => 'public', :action => 'tags'
  # map.connect 'tags/:search', :controller => 'public', :action => 'tags'

  # map.connect 'e/:show_slug/vote/:episode_id', :controller => 'public', :action => 'vote'
  # map.connect 'vote/:episode_id', :controller => 'public', :action => 'vote'

  # map.connect '/e/:show_slug/feed', :controller => 'public', :action => 'feed'
  # map.connect 'feed', :controller => 'public', :action => 'feed'

  # map.connect 'robots.txt', :controller => 'public', :action => 'robots'

  # # You can have the root of your site routed by hooking up ''
  # # -- just remember to delete public/index.html.
  # map.connect '', :controller => "public", :action => "welcome"
  # # prevent /show path in url_for_show
  # map.connect '', :controller => "public", :action => "show"

  # map.connect '/:action', :controller => "public"

  # map.connect ':controller/:action/:id.:format'
  # map.connect ':controller/:action/:id'
end
