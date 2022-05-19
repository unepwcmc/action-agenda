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
      country_ids: country_ids,
      committed_year: @cbd_hash.dig('meta', 'createdOn').to_date.year,
      commitment_source: 'cbd',
      cfn_approved: @commitment.cfn_approved,
      state: 'live',
      shareable: false,
      links_attributes: [
        link_attributes
      ]
    }
  end

  def country_ids
    operational_areas = @cbd_hash.dig('actionDetails', 'operationalAreas')

    return [global_country_id] if operational_areas.nil?

    # CDB returns some records with iso codes and some with a longer id, but the longer
    # codes refer to regions rather than countries so we'll exclude them.
    upcased_iso_codes = operational_areas.map do |operational_area|
      operational_area['identifier'].length == 2 ? operational_area['identifier'].upcase : nil
    end.compact

    countries = Country.where(iso: upcased_iso_codes)
    ids = countries.pluck(:id)
    ids.present? ? ids : [global_country_id]
  end

  def global_country_id
    Country.find_by(iso: '--').id
  end

  def link_attributes
    {
      id: @commitment.links.first&.id,
      url: "https://www.cbd.int/action-agenda/contributions/action?action-id=#{@cbd_hash['_id']}"
    }
  end
end
