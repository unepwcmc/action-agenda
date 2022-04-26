source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
gem 'activerecord-postgis-adapter', '~> 5.2'

# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# gem 'wcmc_components', path: "../web-components/gems/wcmc_components"
gem 'wcmc_components', '~> 0.3.0', source: 'https://gem-server.unep-wcmc.org/'
gem 'will_paginate', '~> 3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: [https://github.com/rails/jbuilder](https://github.com/rails/jbuilder "https://github.com/rails/jbuilder")
gem 'jbuilder', '~> 2.5'
# Use webpack to manage app-like JavaScript modules in Rails
gem 'webpacker', '~> 4.2', '>= 4.2.2'
gem 'httparty'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# ActiveStorage
gem 'mini_magick', '~> 4.8' # Use ActiveStorage variant
gem 'aws-sdk-s3', require: false # Use S3 bucket for document storage
gem 'active_storage_validations', '~> 0.1' # validate upload types

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# authorisation
gem 'devise', '~> 4.8', '>= 4.8.1'

# allow newer key type to be used in deployment
gem "ed25519"
gem "bcrypt_pbkdf"

gem 'rack-cors', '~> 1.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'capistrano', '~> 3.14.1', require: false
  gem 'capistrano-rails',   '~> 1.6.1', require: false
  gem 'capistrano-bundler', '~> 2.0.1', require: false
  gem 'capistrano-rvm',   '~> 0.1.2', require: false
  gem 'capistrano-passenger', '~> 0.2.0', require: false
  gem 'capistrano-yarn'
  gem 'capistrano-rake', require: false
  
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener', '~> 1.7'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]