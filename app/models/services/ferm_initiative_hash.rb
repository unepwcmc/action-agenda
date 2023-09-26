# frozen_string_literal: true

class Services::FermInitiativeHash
  # {
  #   "id": "D42CikBmpZr380HXSgRj",
  #   "title": "Shan-Shui Initiative in China",
  #   "description": "In order to address the challenges of global climate change and biodiversity\nloss, and transform the patterns of previous ecological conservation and restoration directed by a single target or to single ecological element, which were lacking in holistic and systematic approach, Chinese President Xi Jinping and the Chinese government have put forward the concept that “mountains, rivers, forests, farmland, lakes and grasslands are a community of life”, calling for holistic conservation, systematic restoration and integrated governance of ecosystems. The Ministry of Finance, the Ministry of Natural Resources, and\nthe Ministry of Ecology and Environment of China jointly launched the Initiative of Integrated Ecological Conservation and Restoration of Mountains, Rivers, Forests, Farmland, Lakes, Grasslands and Deserts (“Shan-Shui Initiative” for short,“Shan-Shui” represents “mountains and rivers” in Chinese), upon the approval from the State Council in 2016. 2. Measures 2.1 Establish a territorial spatial planning system A scientific and efficient territorial spatial planning system has been established, to coordinate the layout of ecological, agricultural, urban and other functional zones. The Ecological Conservation Redlines, permanent fundamental farmlands, and urban development boundaries are delineated, as well as the protection lines for marine space. The central government has promulgated the Master Plan for Major Projects of Conservation and Restoration of Nationwide Key Ecosystems (2021-2035) (Annex.2), which defines the overall spatial layout and priorities, featuring with “Three Regions and Four Belts” (details in Annex.1). Provincial-level plans for ecological restoration have been developed, and 1/3 have been released. 2.2 Set up special funds and mobilize private investment The central government has invested USD 1.6 billion\neach year since 2016 to support the projects under the Shan-Shui Initiative, which shall meet the following criteria: 1) Comply with the national territorial spatial planning and the special plans for ecological conservation and restoration; 2) Formulate project implementation plans at the landscape and watershed scale or larger scale with quantifiable and assessable performance indicators; 3)The implementation scope should include ecological space, and\nrelated agricultural and urban space; 4)Activities such as land use pattern and intensity adjustment, flood regulation, disaster prevention, and pollution control, should be implemented, reducing the threats of ecosystem. Biodiversity conservation shall be a major goal; 5)Take into account the employment and livelihoods of the communities and villagers; 6)The total amount of local public and private investment generated should be no less than 1.5 times of the amount of the central government investment; 7)Establish a cross-sector\nmechanism for better organization and coordination and integrate multidisciplinary knowledge and local experience into the projects; 8)Establish a monitoring system at different scales, and adaptive management & post-management mechanism. The Opinions of the General Office of the State Council on Encouraging and Supporting the Involvement of Private Capital in Ecological Conservation and Restoration (Annex.3) was issued by Chinese government to diversify the financing. 2.3 Put in place a series of standards A “1+N” system of technical standards for the Shan-Shui Initiative has been developing. It guides practitioners to follow the laws of natural ecosystem succession and intrinsic mechanisms, take into account the integrity, systemic nature and correlation of natural ecological elements, and implement projects for the ecosystems that are damaged, degraded, or with declining services and functions. Besides, in order to mainstream the Shan-Shui Initiative, Chinese government has listed it in many important plans and documents, such as 14th\nFive-Year Plan for Economics and Social Development.",
  #   "website": "",
  #   "startingYear": "2016",
  #   "endingYear": "",
  #   "objectives": [],
  #   "organizations": [
  #     "Ministry of Natural Resources of China"
  #   ],
  #   "targetArea": {
  #     "units": "ha",
  #     "value": 10000000
  #   },
  #   "areaUnderRestoration": "",
  #   "keywords": [
  #     "Flagship"
  #   ],
  #   "pointsOfContact": [
  #     "China Land Consolidation and Rehabilitation"
  #   ],
  #   "indicators": [],
  #   "results": [],
  #   "ecosystems": [
  #     "i.T1 Tropical-subtropical forests biome",
  #     "iii.T3 Shrublands and shrubby woodlands biome",
  #     "v.T5 Deserts and semi-deserts biome",
  #     "iii.MT3 Anthropogenic shorelines biome",
  #     "i.MFT1 Brackish tidal biome",
  #     "vii.T7 Intensive land-use biome",
  #     "ii.T2 Temperate-boreal forests and woodlands biome",
  #     "iv.M4 Anthropogenic marine biome",
  #     "iii.F3 Artificial wetlands biome",
  #     "ii.F2 Lakes biome",
  #     "i.F1 Rivers and streams biome",
  #     "i.TF1 Palustrine wetlands biome",
  #     "i.MT1 Shorelines biome",
  #     "ii.MT2 Supralittoral coastal biome"
  #   ],
  #   "restorationTypes": [],
  #   "tenureStatuses": []
  # }

  def initialize(ferm_initiative_hash, commitment)
    @ferm_initiative_hash = ferm_initiative_hash
    @commitment = commitment
    # @manager_hash = manager_hash
  end

  def call
    {
      ferm_id: @ferm_initiative_hash['_id'],
      name: @ferm_initiative_hash['name'],
      description: @ferm_initiative_hash['description'],
      country_ids: , # missing
      committed_year: , # "startingYear": "2016",  "endingYear": "",
      commitment_source: 'ferm',
      manager_ids: , # type of managers, e.g. NGO, government, etc.
      cfn_approved: @commitment.cfn_approved, # should also automatically decline of it has government managers
      state: , # restoration status missing
      shareable: false,
      links_attributes: [
        link_attributes
      ]
    }
  end

  # def cfn_approved
  #   return false if has_government_managers?

  #   @commitment.cfn_approved
  # end

  # def has_government_managers?
  #   government_manager_ids = [
  #     @manager_hash.dig('Other government'),
  #     @manager_hash.dig('Sub-national government')
  #   ]

  #   (government_manager_ids & manager_ids).any?
  # end

  # def country_ids
  #   operational_areas = @ferm_initiative.dig('actionDetails', 'operationalAreas')

  #   return [global_country_id] if operational_areas.nil?

  #   # CDB returns some records with iso codes and some with a longer id, but the longer
  #   # codes refer to regions rather than countries so we'll exclude them.
  #   upcased_iso_codes = operational_areas.map do |operational_area|
  #     operational_area['identifier'].length == 2 ? operational_area['identifier'].upcase : nil
  #   end.compact

  #   countries = Country.where(iso: upcased_iso_codes)
  #   ids = countries.pluck(:id)
  #   ids.present? ? ids : [global_country_id]
  # end

  # def global_country_id
  #   Country.find_by(iso: '--').id
  # end

  # def link_attributes
  #   {
  #     id: @commitment.links.first&.id,
  #     url: "https://www.cbd.int/action-agenda/contributions/action?action-id=#{@ferm_initiative['_id']}"
  #   }
  # end

  # def manager_ids
  #   @manager_ids ||= begin
  #     actor_data = @ferm_initiative.dig('actor', 'types')
  #     return [] unless actor_data
  #     # Generate a list of ids from out database from the cbd ids
  #     actor_data.map { |actor| cbd_identifier_to_cfn_id(actor['identifier']) }
  #   end
  # end

  # def cbd_identifier_to_cfn_id(id)
  #   manager_name = manager_name_lookup(id)
  #   manager_id_lookup(manager_name)
  # end

  # def manager_id_lookup(name)
  #   @manager_hash.dig(name)
  # end

  # def manager_name_lookup(id)
  #   # CBD API actors
  #   # [
  #   #   {
  #   #     "name"=>"Academic or research institute",
  #   #     "identifier"=>"86D464C3-B5BB-4B02-85E4-1AAD8D64CD27"
  #   #   },
  #   #   {
  #   #     "name"=>"Government agency (National/Federal)",
  #   #     "identifier"=>"8830904C-8AF4-4C2F-AADB-363D98D854DA"
  #   #   },
  #   #   {
  #   #     "name"=>"Government agency (Sub-national)",
  #   #     "identifier"=>"1C3A4FF4-9AB7-4A34-BE06-E07F575B7A32"
  #   #   },
  #   #   {
  #   #     "name"=>"Inter-governmental organization (IGO)",
  #   #     "identifier"=>"64432E86-23C9-4D9A-B835-962D8221E6CA"
  #   #   },
  #   #   {
  #   #     "name"=>"Non-governmental organization (NGO)",
  #   #     "identifier"=>"8A265B81-3973-42ED-BB06-40ACC755E496"
  #   #   },
  #   #   {
  #   #     "name"=>"Private sector (business and industry)",
  #   #     "identifier"=>"90C29DF8-D863-4255-851D-A7A6E8FDFA8F"
  #   #   },
  #   #   {
  #   #     "name"=>"Regional economic integration organization",
  #   #     "identifier"=>"39EA5BC2-FEC4-4946-A543-A4F6E1A2F330"
  #   #   },
  #   #   {
  #   #     "name"=>"UN and other specialized agency of the UN Common System",
  #   #     "identifier"=>"692b3eb1-a00c-437d-8903-d9b7714a7514"
  #   #   },
  #   #   {
  #   #     "identifier": "ORG-TYPE-OTHER",
  #   #     "name": "Other"
  #   #   }
  #   # ]

  #   # Mapping of CBD ids to our Manager types
  #   case id
  #   when '86D464C3-B5BB-4B02-85E4-1AAD8D64CD27', '8A265B81-3973-42ED-BB06-40ACC755E496', '64432E86-23C9-4D9A-B835-962D8221E6CA'
  #     'Non-profit organisation'
  #   when '90C29DF8-D863-4255-851D-A7A6E8FDFA8F'
  #     'For-profit organisation'
  #   when '8830904C-8AF4-4C2F-AADB-363D98D854DA', '692b3eb1-a00c-437d-8903-d9b7714a7514', '39EA5BC2-FEC4-4946-A543-A4F6E1A2F330'
  #     'Other government'
  #   when '1C3A4FF4-9AB7-4A34-BE06-E07F575B7A32'
  #     'Sub-national government'
  #   when 'ORG-TYPE-OTHER'
  #     'Local communities'
  #   end
  # end
end
