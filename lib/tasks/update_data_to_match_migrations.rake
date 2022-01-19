namespace :update_data_to_match_migrations do
  desc ""
  task :add_commitment_country_to_commitment_countries do
    # Commitment used to belong_to a country, now it has_and_belongs_to_many
    Commitment.find_each do |commitment|
      commitment.countries << Country.find(commitment.country_id) if commitment.country_id 
    end
  end
end