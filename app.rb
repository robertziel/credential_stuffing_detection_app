require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'])
Dotenv.load

class CSDApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :root, File.dirname(__FILE__)

  # For details check Constants in Readme.md
  set :ip_ban_time,       (ENV['IP_BAN_TIME'] || 30).to_i
  set :ip_requests_limit, (ENV['IP_REQUESTS_LIMIT'] || 10).to_i
  set :sample_period,     (ENV['SAMPLE_PERIOD'] || 5).to_i
  set :ip_emails_limit,   (ENV['IP_EMAILS_LIMIT'] || 2).to_i

  require File.join(root, '/config/initializers/autoloader.rb')

  use Routes::Detect
end
