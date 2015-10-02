require 'tzinfo'

module MeetupClient
  ENDPOINT = 'https://api.meetup.com/'

  def self.url(path='/', query={})
    query['sign'] = 'true'
    query['photo-host'] = 'public'
    uri = URI.parse ENDPOINT
    uri.path = path
    uri.query = Rack::Utils.build_query(query)
    uri
  end

  # https://www.eventbriteapi.com/v3/events/18896471856/?token=6HXSTR7DTRN7CXZJBIMU
  def self.event(urlname, id)
    event = HTTParty.get(url("/#{urlname}/events/#{id}")).parsed_response
    duration = (event['duration'] || 0) / 1000
    event['timeZone'] = timezone_for(event)
    event['start'] = datetime_for(event, 'time')
    event['end'] = event['start'] + duration
    event
  end

  def self.datetime_for(event, field='time')
    offset = Rational(event['utc_offset'], 24 * 60 * 60 * 1000)
    Time.at(event[field] / 1000).to_datetime.new_offset(offset).to_time
  end

  def self.timezone_for(event)
    offset = event['utc_offset'] / 1000
    timezone = TZInfo::Timezone.all.find do |timezone|
      timezone.current_period.utc_offset == offset
    end
    timezone.canonical_identifier
  end

end
