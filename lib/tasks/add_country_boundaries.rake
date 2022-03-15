desc 'Add country boundaries'
task add_country_boundaries: :environment do
  json_from_file = File.read("#{Rails.root}/lib/data/seeds/boundaries.json")
  hash = JSON.parse(json_from_file)

  Country.all.each do |country|
    boundary = hash[country.iso]
    if boundary
      puts "Adding boundary for #{ country.name }"
      country.boundary = boundary
      country.save!
    end
  end
end