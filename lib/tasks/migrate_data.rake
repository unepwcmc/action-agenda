namespace :migrate_data do
  desc "Updates data to match new DB structure"
  task add_commitment_country_to_commitment_countries: :environment do
    Commitment.find_each do |commitment|
      commitment.countries << Country.find(commitment.country_id) if commitment.country_id
      commitment.save!
    end
    puts "commitment.country converted to commitment.countries"
  end
end