require 'sinatra/activerecord'

require 'redis'
$redis = Redis.new(url: ENV['REDIS_PROVIDER'])

require './model/webhook'
require './model/beat'
