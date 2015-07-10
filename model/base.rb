require 'sinatra/activerecord'

require 'redis'

if ENV['REDISCLOUD_URL']
  uri = URI.parse(ENV['REDISCLOUD_URL'])
  $redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
else
  $redis = Redis.new
end

require './model/webhook'
require './model/beat'
