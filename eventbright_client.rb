module EventbrightClient
  TOKEN = ENV.fetch 'EVENT_BRIGHT_TOKEN'

  ENDPOINT = 'https://www.eventbriteapi.com/v3'

  def self.url(path='/', query={})
    query[:token] = TOKEN
    uri = URI.parse ENDPOINT
    uri.path = "/v3#{path}"
    uri.query = Rack::Utils.build_query(query) unless query.nil?
    uri
  end

  # https://www.eventbriteapi.com/v3/events/18896471856/?token=6HXSTR7DTRN7CXZJBIMU
  def self.event(id)
    HTTParty.get(url("/events/#{id}")).parsed_response
  end

  def self.venue(id)
    HTTParty.get(url("/venues/#{id}")).parsed_response
  end

end
