namespace :migrate_data do
  desc "Updates data to match new DB structure"
  task add_commitment_country_to_commitment_countries: :environment do
    Commitment.find_each do |commitment|
      commitment.countries << Country.find(commitment.country_id) if commitment.country_id
      commitment.save!
    end
    puts "commitment.country converted to commitment.countries"
  end

  task add_commitment_link_to_commitment_links: :environment do
    Commitment.find_each do |commitment|
      commitment.links.create!(url: commitment.link)
    end
    puts "commitment.link converted to commitment.links"
  end

  task add_default_options_for_threats: :environment do
    [Threat, Manager, Action, Objective].each do |klass|
      klass::DEFAULT_OPTIONS.each do |option|
        record = klass.find_by(name: option)
        record ? klass.update(default_option: true) : klass.create(name: option, default_option: true) 
      end
    end
    puts "default options added"
  end
end