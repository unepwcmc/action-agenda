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
      commitment.links.create!(url: commitment.link) if commitment.link
    end
    puts "commitment.link converted to commitment.links"
  end

  task set_existing_commitments_to_live: :environment do
    failed_to_set_live = []
    Commitment.find_each do |commitment|
      commitment.state = :live
      failed_to_set_live << commitment.id unless commitment.save
    end
    puts failed_to_set_live.empty? ? "All commitments set to 'live'." : "Commitments #{ failed_to_set_live.join(', ')} could not be set to live"
  end
end