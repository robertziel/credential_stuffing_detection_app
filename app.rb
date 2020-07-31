require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'])
Dotenv.load

class CSDApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :root, File.dirname(__FILE__)

  require File.join(root, '/config/initializers/autoloader.rb')

  use Routes::Detect
end
