require 'simplecov'
SimpleCov.start

ENV['RACK_ENV'] = 'test'

require File.expand_path('../app', __dir__)

require 'rspec'
require 'rack/test'

Dir[File.join(CSDApp.root, 'spec/support/**/*.rb')].sort.each { |f| require f }

def app
  described_class
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include ResponseHelper

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end
