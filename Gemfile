source 'https://rubygems.org'

ruby File.read(File.expand_path('.ruby-version', __dir__)).chomp

gem 'sinatra'
gem 'sinatra-contrib'

gem 'dotenv'

group :development, :test do
  gem 'pry'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'simplecov'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end
