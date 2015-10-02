require 'meetup_client'

# http://www.meetup.com/Get-Your-Climb-On/events/224410897/
MeetupImporter = -> (url) do

  url.host and \
  url.host.end_with?('meetup.com') and \
  url.path =~ %r{^/([^/]+)/events/(\d+)} or return false
  event_urlname = $1
  event_id = $2

  event = MeetupClient.event(event_urlname, event_id)

  if venue = event['venue']
    location = <<-TEXT
      #{venue['name']}
      #{venue['address_1']}
      #{venue['address_2']}
      #{venue['address_3']}
      #{venue['city']}, #{venue['state']}, #{venue['zip']}
      #{venue['country']}
    TEXT
    location.gsub!(/\s*\n\s*/, "\n").sub!(/^\s+/,'')
  end

  return {
    'summary'     => event['name'],
    'description' => "#{event['link']}\n\n#{event['description']}",
    'location'    => location,
    'start' => {
      'dateTime' => event['start'],
      'timeZone' => event['timeZone'],
    },
    'end' => {
      'dateTime' => event['end'],
      'timeZone' => event['timeZone'],
    },
  }
end
