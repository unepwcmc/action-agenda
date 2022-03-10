desc 'Add country boundaries'
task add_country_boundaries: :environment do
  require "json"
  json_from_file = File.read("#{Rails.root}/lib/data/seeds/boundaries.json")
  hash = JSON.parse(json_from_file)

  Country.all.each do |country|
    boundary = hash[country.iso]
    if boundary
      country.boundary = boundary
      country.save!

      country.lat = country.boundary.centroid.lat
      country.long = country.boundary.centroid.lon
      country.save!
    end
  end
end