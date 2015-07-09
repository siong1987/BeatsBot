require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

require 'omniauth'
require 'omniauth-slack'

require './model/base'
require './environments'

use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET']
use OmniAuth::Builder do
  provider :slack, ENV['SLACK_CLIENT_ID'], ENV['SLACK_CLIENT_SECRET'], scope: 'identify'
end

configure do
  set :public_folder, 'public'
end

helpers do
  def current_user
    @user ||= User.find_by(id: session[:uid])
  end

  def login?
    current_user.present?
  end
end

get '/' do
  @slack_webhook_url = login? ? current_user.slack_webhook_url : ''
  erb :home
end

post '/webhook' do
  current_user.update_attribute(:slack_webhook_url, params[:slack_webhook_url])
  redirect '/', notice: 'Webhook URL added!'
end

get '/logout' do
  session[:uid] = nil
  redirect '/'
end

get '/auth/slack/callback' do
  user = User.find_or_create_by(slack_user_id: request.env['omniauth.auth']['uid'])
  session[:uid] = user.id

  redirect '/', notice: 'Logged in successfully!'
end
