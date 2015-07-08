if ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load
end

require './app'
run Sinatra::Application
