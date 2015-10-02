module EventBrightClient
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
    HTTParty.get url("/events/#{id}")
  end

  def self.from_url(url)
    # http://www.eventbrite.com/e/pop-up-magazine-san-francisco-davies-symphony-hall-tickets-18198722870?aff=ebrowse
    url = URI.parse(url)
    if url.path =~ %r{^/e/.+-(\d+)$}
      event($1)
    else
      raise "unable to determine event if from url: #{url}"
    end
  end

end
