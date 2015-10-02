require File.expand_path('../environment', __FILE__)

require 'calendar'
require 'google_client'
require 'event_importer'

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

  def calendar_path(calendar_id)
    "/calendars/#{Rack::Utils.escape(calendar_id)}"
  end

end


error Google::Apis::AuthorizationError do |error|
  status 401
  haml :unauthorized
end

error do |error|
  status 500
  error.message
end

get '/' do
  if signed_in?
    redirect to('/calendars')
  else
    haml :homepage
  end
end


get '/logout' do
  session.clear
  redirect to '/'
end

get '/login-via-google' do
  session.clear
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

post '/calendars/:id/events' do
  @calendar = google_client.calendar(params[:id])
  if url = params[:url]
    @event = EventImporter.from_url(url) and \
    @calendar.create_event(@event) and \
    flash[:notice] = 'Event Imported' or \
    flash[:error] = "Failed to Import Event from #{url.inspect}"
  end
  redirect to("/calendars/#{@calendar.id}")
end
