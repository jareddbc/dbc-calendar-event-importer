require 'spec_helper'
require 'importers/eventbright_importer'

describe EventbrightImporter do

  context 'when given an unmatched url' do
    let(:url){ URI.parse('http://google.com') }
    it 'should return false' do
      expect(EventbrightImporter.call(url)).to be false
    end
  end

  context 'when given a matching url' do
    let(:url){ URI.parse('http://www.eventbrite.com/e/pop-up-magazine-san-francisco-davies-symphony-hall-tickets-18198722870?aff=ebrowse') }

    let :event_data do
      {"name"=>
        {"text"=>"Pop-Up Magazine | San Francisco | Davies Symphony Hall",
         "html"=>"Pop-Up Magazine | San Francisco | Davies Symphony Hall"},
       "description"=> {
          "text"=> "Pop-Up Magazine description here",
          "html"=> "<h1>Pop-Up Magazine description here</h1>"
        },
       "id"=>"18198722870",
       "url"=>
        "http://www.eventbrite.com/e/pop-up-magazine-san-francisco-davies-symphony-hall-tickets-18198722870",
       "start"=>
        {"timezone"=>"America/Los_Angeles",
         "local"=>"2015-10-08T19:30:00",
         "utc"=>"2015-10-09T02:30:00Z"},
       "end"=>
        {"timezone"=>"America/Los_Angeles",
         "local"=>"2015-10-08T21:30:00",
         "utc"=>"2015-10-09T04:30:00Z"},
       "created"=>"2015-08-18T01:28:11Z",
       "changed"=>"2015-10-01T23:59:41Z",
       "capacity"=>2449,
       "status"=>"live",
       "currency"=>"USD",
       "listed"=>true,
       "shareable"=>true,
       "online_event"=>false,
       "tx_time_limit"=>360,
       "hide_start_date"=>false,
       "logo_id"=>"15123642",
       "organizer_id"=>"7284336907",
       "venue_id"=>"8662167",
       "category_id"=>"113",
       "subcategory_id"=>nil,
       "format_id"=>"6",
       "resource_uri"=>"https://www.eventbriteapi.com/v3/events/18198722870/",
       "logo"=>
        {"id"=>"15123642",
         "url"=>
          "https://img.evbuc.com/http%3A%2F%2Fcdn.evbuc.com%2Fimages%2F15123642%2F92535363833%2F1%2Foriginal.jpg?h=200&w=450&s=8666de5cd6a8c83858074825ad772591",
         "aspect_ratio"=>"1.77",
         "edge_color"=>"#ffc905",
         "edge_color_set"=>true}}
    end

    let :venue_data do
      {"address"=>
        {"address_1"=>"201 Van Ness Ave",
         "address_2"=>nil,
         "city"=>"San Francisco",
         "region"=>"CA",
         "postal_code"=>nil,
         "country"=>"US",
         "latitude"=>37.7776493,
         "longitude"=>-122.42046690000001},
       "resource_uri"=>"https://www.eventbriteapi.com/v3/venues/8662167/",
       "id"=>"8662167",
       "name"=>"Davies Symphony Hall",
       "latitude"=>"37.7776493",
       "longitude"=>"-122.42046690000001"}
    end

    before do
      expect(EventbrightClient).to receive(:event).with('18198722870').and_return(event_data)
      expect(EventbrightClient).to receive(:venue).with('8662167').and_return(venue_data)
    end

    it 'should return an event' do
      expect(EventbrightImporter.call(url)).to eq(
        "summary" => "Pop-Up Magazine | San Francisco | Davies Symphony Hall",
        "description" => "Pop-Up Magazine description here",
        "location"=> "Davies Symphony Hall\n201 Van Ness Ave\nSan Francisco, CA,\nUS\n",
        "start"=> {
          "dateTime" => "2015-10-08T19:30:00",
          "timeZone"=>"America/Los_Angeles",
        },
        "end"=>{
          "dateTime"=>"2015-10-08T21:30:00",
          "timeZone"=>"America/Los_Angeles",
        }
      )
    end
  end

end
