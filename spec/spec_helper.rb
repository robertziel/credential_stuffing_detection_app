require 'simplecov'
SimpleCov.start

ENV['RACK_ENV'] = 'test'

require File.expand_path('../app', __dir__)

require 'rspec'
require 'rack/test'

Dir[File.join(CSDApp.root, 'spec/support/**/*.rb')].sort.each { |f| require f }
Dir[File.join(CSDApp.root, 'spec/factories/**/*.rb')].sort.each { |f| require f }

def app
  described_class
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Rack::Test::Methods
  config.include ResponseHelper
  config.include Shoulda::Matchers::ActiveModel
  config.include Shoulda::Matchers::ActiveRecord

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
  end
end
