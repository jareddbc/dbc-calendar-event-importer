require File.expand_path('../environment', __FILE__)

require 'calendar'

# require 'googleauth'
# require 'google/apis/compute_v1'

# compute = Google::Apis::ComputeV1::ComputeService.new

# # Get the environment configured authorization
# scopes =  ['https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/compute']
# compute.authorization = Google::Auth.get_application_default(scopes)


# result = client.execute(:api_method => service.calendars.get,
#                         :parameters => {'calendarId' => 'primary'})
# calendar = result.data
# calendar.summary = "New Summary"
# result = client.execute(:api_method => service.calendars.update,
#                         :parameters => {'calendarId' => calendar.id},
#                         :body_object => calendar,
#                         :headers => {'Content-Type' => 'application/json'})
# print result.data.etag
