source 'https://rubygems.org'

gem 'rails', '2.3.18'
gem 'inherited_resources', '= 1.0.6'
gem 'RedCloth'
gem 'red_cloth_formatters_plain'

gem 'will_paginate', '~> 2.3.16'

gem 'liquid'
gem 'exception_notification'
gem 'acts-as-list'

gem 'httparty'
gem 'audiobank-client', '~> 0.0.2'

group :development do
  gem "sqlite3-ruby"
  gem 'rmagick'
  gem 'capistrano'
end

group :development, :test do
  gem "guard"
  gem 'guard-rspec'
  gem 'guard-cucumber'
end

group :test do
  gem 'rspec-rails', '< 2'
  gem 'rcov'
  gem 'remarkable_rails'
  gem 'factory_girl'
  gem 'fakeweb'
end

group :cucumber do
  gem "capybara", "1.1.1"
  gem "cucumber", "1.1.0"
  gem "cucumber-rails", "0.3.2"

  gem 'webrat'
  gem 'database_cleaner'
  gem 'pickle'
  gem 'factory_girl'
  gem "launchy"
  gem "gherkin"
end

group :production do
  gem 'SyslogLogger'
  gem 'mysql'
end
