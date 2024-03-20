class Services::FermImporter
  BASE_URL = 'https://data.apps.fao.org/fao-ferm' #/apidocs'
  INITIATIVES_URL = "#{BASE_URL}/initiatives"
  MAPPING_URL = "#{BASE_URL}/categorical_mappings"

  def call
    manager_hash = Hash[Manager.pluck(:name, :id)]
    objective_hash = Hash[Objective.pluck(:name, :id)]
    action_hash = Hash[Action.pluck(:name, :id)]
    categorical_mappings_hash = categorical_mappings_call
    initiatives.each do |initiative_hash|
      begin
        commitment = Commitment.find_or_initialize_by(ferm_id: initiative_hash['id'])
        commitment_params = Services::FermInitiativeHash.new(initiative_hash, commitment, manager_hash, action_hash, objective_hash, categorical_mappings_hash).call
        commitment.assign_attributes(commitment_params)
        commitment.save!
      rescue => e
        puts "Error importing or updating FERM initiative #{initiative_hash['id']}: #{e.message}"
      end
    end
  end

  private

  def initiatives
    HTTParty.get(INITIATIVES_URL)
  end

  def categorical_mappings_call
    HTTParty.get(MAPPING_URL)
  end
end
