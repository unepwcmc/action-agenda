class Services::CbdCommitmentHash
  def initialize(cbd_hash, commitment)
    @cbd_hash = cbd_hash
    @commitment = commitment
  end

  def call
    cbd_action = @cbd_hash["action"]
    country = @cbd_hash["contacts"][0]["country"].present? ? Country.find_by(iso: @cbd_hash["contacts"][0]["country"]["identifier"].upcase)
        : Country.find_by(iso: "--")

    {
      cbd_id: @cbd_hash["_id"],
      name: cbd_action["name"]["en"],
      description: cbd_action["description"]["en"],
      country_ids: [country.id],
      committed_year: @cbd_hash["meta"]["createdOn"].to_date.year,
      commitment_source: 'cbd',
      cfm_approved: @commitment.cfm_approved,
      state: 'live',
      shareable: false,
      links_attributes: [
        link_attributes: link_attributes
      ]
    }
  end

  def link_attributes
    {
      id: @commitment.links.first&.id,
      url: "https://www.cbd.int/action-agenda/contributions/action?action-id=#{@cbd_hash["_id"]}"
    }
  end
end
