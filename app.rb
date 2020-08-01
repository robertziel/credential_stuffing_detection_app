require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'])
Dotenv.load

class CSDApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :root, File.dirname(__FILE__)

  # For details check Constants in Readme.md
  set :ip_ban_time,      ENV['IP_BAN_TIME'] || 30
  set :ip_limit,         ENV['IP_LIMIT'] || 10
  set :sample_period,    ENV['SAMPLE_PERIOD'] || 5
  set :ip_emails_limit,  ENV['IP_EMAILS_LIMIT'] || 2

  require File.join(root, '/config/initializers/autoloader.rb')

  use Routes::Detect
end
