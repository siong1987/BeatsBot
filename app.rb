require 'sinatra'
require 'faraday'
require 'uri'

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

get '/latest' do
  song = $redis.get('latest')
  song
end

get '/done' do
  erb :done
end

post '/webhook' do
  url = params[:slack_webhook_url]
  if url =~ URI::regexp
    beat = Beat.last
    begin
      response = Webhook.post_to_slack(url, beat)
    rescue
      redirect '/start'
      return
    end

    if response.status != 200
      redirect '/start'
      return
    end

    Webhook.find_or_create_by(url: url)
    redirect '/done'
  else
    redirect '/start'
  end
end

get '/logout' do
  session[:uid] = nil
  redirect '/'
end
