BonnesOndes::Application.routes.draw do
  constraints(ResourceLink::AdminHost) do
    root :to => 'admin/welcome#show', :as => :public

    resources :audiobank_updates

    match 'compte' => "admin/dashboards#show", :as => :admin

    namespace :admin, :path => "compte" do
      resource :dashboard

      match 'activate/:code' => 'account#active', :as => :activate
      match 'login' => 'account#login', :as => :login
      match 'logout' => 'account#logout', :as => :logout
      match 'signup' => 'account#signup', :as => :signup
      match 'recover_password' => 'account#recover_password', :as => :recover_password

      resources :shows do
        collection do
          post 'slug'
        end

        resource :logo
        resources :episodes do
          collection do
            post 'slug'
          end

          resource :episode_image, :path => "image", :as => "image"
          resources :contents
          resources :net_contents
          resources :audiobank_contents
        end
        resources :posts do
          collection do
            post 'slug'
          end
        end
        resources :pages do
          collection do
            post 'slug'
          end
          member do
            get 'move_up'
          end
        end
        resources :images
      end

      resources :templates
    end
  end

  scope :module => "public", :as => "public" do
    def show_resources(context)
      context.resources :episodes, :path => "ep" do
        resources :contents, :path => "c"
        resource :vote
      end
      context.resources :pages, :path => "p"
      context.resources :posts
      context.resources :tags
      context.resource :feed, :defaults => { :format => "xml" }
      context.resource :robots
      context.resource :sitemap
      context.resource :stream, :path => "direct"
    end

    constraints(ResourceLink::ShowHost) do
      root :to => "show#show"
      show_resources self
    end

    constraints(ResourceLink::RadioHost) do
      root :to => 'radio#show'
      resources :shows, :path => "e" do
        show_resources self
      end
      resource :robots
      resource :sitemap, :defaults => { :format => "xml" }
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
