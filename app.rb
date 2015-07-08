require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

require 'omniauth'
require 'omniauth-slack'
require 'byebug'

require './environments'

class User < ActiveRecord::Base
  validates :slack_user_id, presence: true, uniqueness: true
end

use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET']
use OmniAuth::Builder do
  provider :slack, ENV['SLACK_CLIENT_ID'], ENV['SLACK_CLIENT_SECRET'], scope: 'identify'
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
  @token = login? ? current_user.slack_bot_token : ''
  erb :home
end

post '/token' do
  current_user.update_attribute(:slack_bot_token, params[:token])
  redirect '/', notice: 'Token updated!'
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
