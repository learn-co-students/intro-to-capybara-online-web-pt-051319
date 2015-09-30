require 'capybara/rspec'
require 'capybara/dsl'

RSpec.configure do |config|
  config.include Capybara::DSL
  config.order = 'default'
end

def app
  Rack::Builder.parse_file('config.ru').first
end

Capybara.app = app
