source 'https://rubygems.org'

gem 'rails', '2.3.8'
gem 'inherited_resources', '= 1.0.6'
gem 'RedCloth'
gem 'liquid'
gem 'exception_notification'
gem 'acts-as-list'

gem 'httparty'

group :development do
  gem "sqlite3-ruby"
  gem 'rmagick'
  gem 'capistrano'
end

group :development, :test do
  gem "guard"
  gem 'guard-rspec'
end

group :test do
  gem 'rspec-rails', '< 2'
  gem 'rcov'
  gem 'remarkable_rails'
  gem 'factory_girl'
  gem 'fakeweb'
end

group :cucumber do
  gem 'webrat'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'pickle'
  gem 'factory_girl'
  gem "launchy"
  gem "gherkin"
end

group :production do
  gem 'SyslogLogger'
  gem 'mysql'
end
