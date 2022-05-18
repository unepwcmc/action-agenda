class Services::CbdImporter

  def call
    first_item_position = 0
    loop do
      response = HTTParty.get(query(first_item_position))

      # We are requesting 10 items per page, so increment the first_item_position by 10.
      first_item_position += 10
      raw_json = JSON.parse(response.body)
      
      break if raw_json.empty?

      raw_json.each do |cbd_com|
        next if cbd_com.nil?

        commitment = Commitment.find_or_initialize_by(cbd_id: cbd_com["_id"])
        commitment_params = Services::CbdCommitmentHash.new(cbd_com, commitment).call
        commitment.assign_attributes(commitment_params)
        commitment.save!
      end
    end
  end

  def query(first_item_position)
    filter_query = "%7B%22identifier%22%3A%22CLIMATE-MITIGATION-AND-ADAPTATION%22%7D%2C%7B%22identifier%22%3A%22LAND-ECOSYSTEMS%22%7D%2C%7B%22identifier%22%3A%22SPECIES%22%7D%2C%7B%22identifier%22%3A%22FRESHWATER-COASTAL-AND-OCEAN-ECOSYSTEMS%22%7D"
    "https://www.cbd.int/api/v2019/actions?q=%7B%22actionDetails.actionCategories%22%3A%7B%22%24in%22%3A%5B#{filter_query}%5D%7D%7D&sk=#{first_item_position}&s=%7B%22meta.modifiedOn%22%3A-1%7D&f=%7B%22actionDetails.actionCategories%22%3A1%2C%22actionDetails.orgTypes%22%3A1%2C%22actionDetails.sdgs%22%3A1%2C%22actionDetails.thematicAreas%22%3A1%2C%22actionDetails.operationalAreas%22%3A1%2C%22contacts.country.identifier%22%3A1%2C%22meta%22%3A1%2C%22action.name%22%3A1%2C%22action.description%22%3A1%2C%22action.image%22%3A1%7D&l=10"
  end
end
