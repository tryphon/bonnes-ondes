source 'https://rubygems.org'

gem 'rails', '3.2.14'

gem 'inherited_resources', '< 1.4'
gem 'simple_form'

gem 'user_interface', :git => 'git://projects.tryphon.priv/user-interface', :branch => 'rails3' #, :path => "~/Projects/UserInterface"

gem 'RedCloth'
gem 'red_cloth_formatters_plain'
gem 'will_paginate'
gem 'liquid'
gem 'exception_notification'
gem 'acts-as-list'
gem 'audiobank-client', '~> 0.0.2'

gem 'dragonfly'
gem 'rack-cache'

gem 'dynamic_form'

gem 'rack-google-analytics'
gem 'rails-i18n'

gem 'acts-as-rated', :git => 'git://github.com/bteitelb/acts-as-rated.git'
gem 'acts_as_taggable_on_steroids'

gem 'json'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# to support Ruby 1.8.7 :
gem 'nokogiri', '~> 1.5.10'

group :development do
  gem "sqlite3-ruby"
  gem 'capistrano'
end

group :development, :test do
  gem 'pry-rails'

  gem 'rspec-rails', '~> 2.0'

  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'

  gem 'pickle'
  gem "shoulda-matchers"
  gem 'fakeweb'
  gem 'launchy'

  # to support Ruby 1.8.7 :
  gem "capybara", "< 2"
  gem 'factory_girl', "< 3"

  gem "guard"
  gem 'guard-rspec'
  gem 'guard-cucumber'
  group :linux do
    gem 'rb-inotify'
    gem 'libnotify'
  end
end

group :production do
  gem 'SyslogLogger', :require => "syslog/logger" 
  gem 'mysql'
end
