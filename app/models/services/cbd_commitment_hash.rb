# frozen_string_literal: true

class Services::CbdCommitmentHash
  def initialize(cbd_hash, commitment, manager_hash)
    @cbd_hash = cbd_hash
    @commitment = commitment
    @manager_hash = manager_hash
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
      manager_ids: manager_ids,
      cfn_approved: cfn_approved,
      state: 'live',
      shareable: false,
      links_attributes: [
        link_attributes
      ]
    }
  end

  def cfn_approved
    return false if has_government_managers?

    @commitment.cfn_approved
  end

  def has_government_managers?
    government_manager_ids = [
      @manager_hash.dig('Other government'),
      @manager_hash.dig('Sub-national government')
    ]

    (government_manager_ids & manager_ids).any?
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

  def manager_ids
    @manager_ids ||= begin
      actor_data = @cbd_hash.dig('actor', 'types')
      return [] unless actor_data
      # Generate a list of ids from out database from the cbd ids
      actor_data.map { |x| cbd_identifier_to_cfn_id(x['identifier']) }
    end
  end

  def cbd_identifier_to_cfn_id(id)
    manager_name = manager_name_lookup(id)
    manager_id_lookup(manager_name)
  end

  def manager_id_lookup(name)
    @manager_hash.dig(name)
  end

  def manager_name_lookup(id)
    # CBD API actors
    # [
    #   {
    #     "name"=>"Academic or research institute",
    #     "identifier"=>"86D464C3-B5BB-4B02-85E4-1AAD8D64CD27"
    #   },
    #   {
    #     "name"=>"Government agency (National/Federal)",
    #     "identifier"=>"8830904C-8AF4-4C2F-AADB-363D98D854DA"
    #   },
    #   {
    #     "name"=>"Government agency (Sub-national)",
    #     "identifier"=>"1C3A4FF4-9AB7-4A34-BE06-E07F575B7A32"
    #   },
    #   {
    #     "name"=>"Inter-governmental organization (IGO)",
    #     "identifier"=>"64432E86-23C9-4D9A-B835-962D8221E6CA"
    #   },
    #   {
    #     "name"=>"Non-governmental organization (NGO)",
    #     "identifier"=>"8A265B81-3973-42ED-BB06-40ACC755E496"
    #   },
    #   {
    #     "name"=>"Private sector (business and industry)",
    #     "identifier"=>"90C29DF8-D863-4255-851D-A7A6E8FDFA8F"
    #   },
    #   {
    #     "name"=>"Regional economic integration organization",
    #     "identifier"=>"39EA5BC2-FEC4-4946-A543-A4F6E1A2F330"
    #   },
    #   {
    #     "name"=>"UN and other specialized agency of the UN Common System",
    #     "identifier"=>"692b3eb1-a00c-437d-8903-d9b7714a7514"
    #   },
    #   {
    #     "identifier": "ORG-TYPE-OTHER",
    #     "name": "Other"
    #   }
    # ]

    # Mapping of CBD ids to our Manager types
    case id
    when '86D464C3-B5BB-4B02-85E4-1AAD8D64CD27', '8A265B81-3973-42ED-BB06-40ACC755E496', '64432E86-23C9-4D9A-B835-962D8221E6CA'
      'Non-profit organisation'
    when '90C29DF8-D863-4255-851D-A7A6E8FDFA8F'
      'For-profit organisation'
    when '8830904C-8AF4-4C2F-AADB-363D98D854DA', '692b3eb1-a00c-437d-8903-d9b7714a7514', '39EA5BC2-FEC4-4946-A543-A4F6E1A2F330'
      'Other government'
    when '1C3A4FF4-9AB7-4A34-BE06-E07F575B7A32'
      'Sub-national government'
    when 'ORG-TYPE-OTHER'
      'Local communities'
    end
  end
end
