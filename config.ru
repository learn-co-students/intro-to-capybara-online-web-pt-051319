# Write your code here!
require 'sinatra'

require_relative './app'

run Application

# define our app -- Rack::Builder.parse_file('config.ru').first
