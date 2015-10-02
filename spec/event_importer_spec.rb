require 'spec_helper'
require 'event_importer'

describe EventImporter do

  describe '.from_url' do

    context 'when given an unknown url' do
      let(:url){ 'http://google.com' }
      it 'should return false' do
        expect(EventImporter.from_url(url)).to be false
      end
    end

    context 'when given an unknown url' do
      let(:url){ 'http://www.eventbrite.com/e/pop-up-magazine-san-francisco-davies-symphony-hall-tickets-18198722870?aff=ebrowse' }
      it 'should return false' do
        expect(EventImporter.from_url(url)).to be false
      end
    end

  end

end
