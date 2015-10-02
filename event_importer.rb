module EventImporter

  def self.from_url(url)
    url = URI.parse(url)
    IMPORTERS.each do |importer|
      event = importer.call(url)
      return event if event
    end
    false
  end

  IMPORTERS = []

  require 'importers/eventbright_importer'
  IMPORTERS << EventbrightImporter

end
