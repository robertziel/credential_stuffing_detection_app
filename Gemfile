source 'https://rubygems.org'

ruby File.read(File.expand_path('.ruby-version', __dir__)).chomp

# Core

gem 'sinatra'
gem 'sinatra-contrib'
gem 'puma'
gem 'rake'

# Database

gem 'pg'
gem 'sinatra-activerecord'

# Security

gem 'dotenv'

group :development, :test do
  gem 'pry'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec'
  gem 'rack-test'
  gem 'shoulda'
  gem 'simplecov'
end
