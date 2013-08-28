ActionController::Routing::Routes.draw do |map|

  map.admin 'compte', :controller => 'Admin::Dashboards', :action => 'show'

  map.with_options(:path_prefix => "compte", :name_prefix => "admin_", :namespace => "admin/") do |admin|
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

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  map.resources :audiobank_updates

  map.public '', :controller => "welcome", :action => 'show'

  map.connect 'e/:show_slug', :controller => 'public', :action => 'show'

  map.connect 'e/:show_slug/p/:page_slug', :controller => 'public', :action => 'page'
  map.connect 'p/:page_slug', :controller => 'public', :action => 'page'

  map.connect 'e/:show_slug/ep/:episode_slug', :controller => 'public', :action => 'episode'
  map.connect 'ep/:episode_slug', :controller => 'public', :action => 'episode'

  map.connect 'e/:show_slug/ep/:episode_slug/ecoute/:content_slug', :controller => 'public', :action => 'content'
  map.connect 'ep/:episode_slug/ecoute/:content_slug', :controller => 'public', :action => 'content'

  map.connect 'e/:show_slug/ep/:episode_slug/ecouter/:content_slug', :controller => 'public', :action => 'playlist'
  map.connect 'ep/:episode_slug/ecouter/:content_slug', :controller => 'public', :action => 'playlist'

  map.connect 'e/:show_slug/tags/:search', :controller => 'public', :action => 'tags'
  map.connect 'tags/:search', :controller => 'public', :action => 'tags'

  map.connect 'e/:show_slug/vote/:episode_id', :controller => 'public', :action => 'vote'
  map.connect 'vote/:episode_id', :controller => 'public', :action => 'vote'

  map.connect '/e/:show_slug/feed', :controller => 'public', :action => 'feed'
  map.connect 'feed', :controller => 'public', :action => 'feed'

  map.connect 'robots.txt', :controller => 'public', :action => 'robots'

  # You can have the root of your site routed by hooking up ''
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "public", :action => "welcome"
  # prevent /show path in url_for_show
  map.connect '', :controller => "public", :action => "show"

  map.connect '/:action', :controller => "public"

  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
