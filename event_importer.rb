module EventImporter

  def self.from_url(url)
    url = URI.parse(url)
    importers.each do |importer|
      event = importer.try(url)
      return event if event
    end
  end

  IMPORTERS = []

  require 'importers/eventbright_importer'
  IMPORTERS << EventbrightImporter

end
