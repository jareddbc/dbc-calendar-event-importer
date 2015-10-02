# require 'googleauth'
require 'google/api_client/client_secrets'
require 'google/apis/calendar_v3'

require 'google/apis/calendar_v3'



class GoogleClient

  GOOGLE_CLIENT_SECRET_JSON = ENV.fetch 'GOOGLE_CLIENT_SECRET_JSON'


  def initialize(options={})
    @oauth2callback_url = options[:oauth2callback_url]
    @token = options[:token]

    @auth_client = if authorized?
      Signet::OAuth2::Client.new JSON.parse(@token)
    else
      @client_secrets = Google::APIClient::ClientSecrets.new(
        MultiJson.load(GOOGLE_CLIENT_SECRET_JSON)
      )
      @client_secrets.to_authorization
    end

    @auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/calendar',
      :redirect_uri => @oauth2callback_url
    )
  end

  def authorized?
    !@token.nil?
  end

  def authorization_uri
    @auth_client.authorization_uri.to_s
  end

  def fetch_access_token(code)
    @auth_client.code = code
    @auth_client.fetch_access_token!
  end

  # Calendar = Google::Apis::CalendarV3
  def calendar_service
    @calendar_service or begin
      @calendar_service = Google::Apis::CalendarV3::CalendarService.new
      @calendar_service.authorization = @auth_client
      @calendar_service
    end
  end

  def calendars
    calendar_service.list_calendar_lists.items.map do |item|
      Calendar.new(self, item)
    end
  end

  def calendar(id)
    Calendar.new self, calendar_service.get_calendar(id)
  end



  class Calendar

    Event = ::Google::Apis::CalendarV3::Event
    EventDateTime = ::Google::Apis::CalendarV3::EventDateTime

    attr_reader :id, :summary, :description

    def initialize(google_client, calendar)
      @google_client = google_client
      @calendar = calendar
      @id = calendar.id
      @summary = calendar.summary
      @description = calendar.description
    end

    def embed_url
      url = URI.parse('https://www.google.com/calendar/embed')
      url.query = Rack::Utils.build_query(src: @id)
      url.to_s
    end

    def create_event(data)
      event = Event.new
      event.summary     = data['summary']
      event.description = data['description']
      event.location    = data['location']
      event.start = EventDateTime.new(
        date_time: DateTime.parse(data['start']['dateTime']),
        time_zone: data['start']['timeZone'],
      )
      event.end = EventDateTime.new(
        date_time: DateTime.parse(data['end']['dateTime']),
        time_zone: data['end']['timeZone'],
      )
      @google_client.calendar_service.insert_event(@id, event, send_notifications: true)
    end

  end

end


