require 'eventbright_client'

# http://www.eventbrite.com/e/pop-up-magazine-san-francisco-davies-symphony-hall-tickets-18198722870?aff=ebrowse
EventbrightImporter = -> (url) do

  url.host and \
  url.host.end_with?('eventbrite.com') and \
  url.path =~ %r{^/e/.+-(\d+)$} or return false
  event_id = $1

  event = EventbrightClient.event(event_id)
  venue = EventbrightClient.venue(event['venue_id'])

  location = <<-TEXT
    #{venue['name']}
    #{venue['address']['address_1']}
    #{venue['address']['address_2']}
    #{venue['address']['city']}, #{venue['address']['region']}, #{venue['address']['postal_code']}
    #{venue['address']['country']}
  TEXT
  location.gsub!(/\s*\n\s*/, "\n").sub!(/^\s+/,'')

  return {
    'summary'     => event['name']['text'],
    'description' => event['description']['text'],
    'location'    => location,
    'start' => {
      'dateTime' => event['start']['local'],
      'timeZone' => event['start']['timezone'],
    },
    'end' => {
      'dateTime' => event['end']['local'],
      'timeZone' => event['end']['timezone'],
    },
  }
end
