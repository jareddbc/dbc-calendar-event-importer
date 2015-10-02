require 'spec_helper'
require 'event_importer'

describe EventImporter do

  describe '.from_url' do

    let(:url){ 'http://google.com' }

    context 'when an importer doesnt return an event' do
      it 'should return false' do
        expect(EventImporter.from_url(url)).to be false
      end
    end

    context 'when an importer returns an event' do
      let(:event){ double(:event) }
      before do
        expect(EventbrightImporter).to receive(:call).and_return(event)
      end
      it 'should return false' do
        expect(EventImporter.from_url(url)).to be event
      end
    end


  end

end
