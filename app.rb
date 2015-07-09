require 'sinatra'

require './model/base'
require './environments'

configure do
  set :public_folder, 'public'
end

get '/' do
  erb :home
end

get '/start' do
  erb :start
end

get '/done' do
  erb :done
end

post '/webhook' do
  # TODO: check URL here
  Webhook.find_or_create_by(url: params[:slack_webhook_url])
  redirect '/done'
end

get '/logout' do
  session[:uid] = nil
  redirect '/'
end
