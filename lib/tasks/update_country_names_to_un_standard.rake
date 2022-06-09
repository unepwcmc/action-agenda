desc 'Update country names to UN standard'
task update_country_names_to_un_standard: :environment do

  iso_codes_and_correct_name = [
    { iso: 'CI', name:	'Côte d’Ivoire' },
    { iso: 'CD', name:	'Democratic Republic of the Congo' },
    { iso: 'GF', name:	'French Guiana' },
    { iso: 'HK', name:	'Hong Kong SAR' },
    { iso: 'MO', name:	'Macau SAR' },
    { iso: 'SJ', name:	'Svalbard and Jan Mayen Islands' }
  ]

  iso_codes_and_correct_name.each do |country_object|
    puts "updating #{ country_object[:name] }"
    country = Country.find_by(iso: country_object[:iso])
    country.update(name: country_object[:name])
  end
end