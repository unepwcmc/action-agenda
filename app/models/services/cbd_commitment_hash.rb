class Services::CbdCommitmentHash
  def initialize(cbd_hash, commitment)
    @cbd_hash = cbd_hash
    @commitment = commitment
  end

  def call
    cbd_action = @cbd_hash['action']

    {
      cbd_id: @cbd_hash['_id'],
      name: cbd_action.dig('name', 'en'),
      description: cbd_action.dig('description', 'en'),
      country_ids: [country_id],
      committed_year: @cbd_hash.dig('meta', 'createdOn').to_date.year,
      commitment_source: 'cbd',
      cfn_approved: @commitment.cfn_approved,
      state: 'live',
      shareable: false,
      links_attributes: [
        link_attributes: link_attributes
      ]
    }
  end

  def country_id
    # @TODO: Change this if CBD changes gives us different information.
    country_object = @cbd_hash['contacts'][0]['country']

    # If no country is found, assign to the 'Global' country record.
    country_code = country_object.present? ? country_object['identifier'].upcase : '---'
    Country.find_by(iso: country_code)
    country.id
  end

  def link_attributes
    {
      id: @commitment.links.first&.id,
      url: "https://www.cbd.int/action-agenda/contributions/action?action-id=#{@cbd_hash['_id']}"
    }
  end
end
