require File.expand_path('../environment', __FILE__)

require 'calendar'
require 'google_client'

helpers do

  def oauth2callback_url
    to('/oauth2callback')
  end

  def google_client
    @google_client ||= GoogleClient.new(
      token: session[:google_access_token],
      oauth2callback_url: oauth2callback_url,
    )
  end

  def signed_in?
    google_client.authorized?
  end

end

get '/' do
  if signed_in?
    redirect to('/calendars')
  else
    haml :homepage
  end
end


get '/login-via-google' do
  redirect google_client.authorization_uri
end


get '/oauth2callback' do
  token = google_client.fetch_access_token(params['code'])
  session[:google_access_token] = token.to_json
  redirect to '/'
end


get '/calendars' do
  @calendars = google_client.calendars
  haml :'calendars/index'
end

get '/calendars/:id' do
  @calendar = google_client.calendar(params[:id])
  haml :'calendars/show'
end
