require 'rack-google-analytics'

middleware = Rails.respond_to?(:application) ? Rails.application.middleware : ActionController::Dispatcher.middleware
middleware.use Rack::GoogleAnalytics, :tracker => 'UA-1896598-5' #, :domain => 'bonnes-ondes.fr', :multiple => true
