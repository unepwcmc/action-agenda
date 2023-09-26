class Services::FermImporter
  # https://data.apps.fao.org/fao-ferm/apidocs
  BASE_URL = '' 
  INITIATIVES_URL = "#{BASE_URL}/initiatives"

  def call
    initiatives.each do |initiative_hash|
      begin
        commitment = Commitment.find_or_initialize_by(ferm_id: initiative_hash[:id])
        commitment_params = Services::FermInitiativeHash.new(initiative_hash, commitment).call
        commitment.assign_attributes(commitment_params)
        commitment.save!
      rescue => e
        puts "Error importing or updating FERM initiative #{initiative[:id]}: #{e.message}"
      end
    end

    # manager_hash = Hash[Manager.pluck(:name, :id)]
    # first_item_position = 0
    # loop do
    #   response = HTTParty.get(query(first_item_position))

    #   # We are requesting 10 items per page, so increment the first_item_position by 10.
    #   first_item_position += 10
    #   raw_json = JSON.parse(response.body)

    #   break if raw_json.empty?

    #   raw_json.each do |cbd_com|
    #     next if cbd_com.nil?

    #     commitment = Commitment.find_or_initialize_by(cbd_id: cbd_com["_id"])
    #     commitment_params = Services::CbdCommitmentHash.new(cbd_com, commitment, manager_hash).call
    #     commitment.assign_attributes(commitment_params)
    #     commitment.save!
    #   end
    # end
  end

  private

  def initiatives
    # TODO: get data from FERM API
    # HTTParty.get(INITIATIVES_URL)
    [
      {
        "id": "D42CikBmpZr380HXSgRj",
        "title": "Shan-Shui Initiative in China",
        "description": "In order to address the challenges of global climate change and biodiversity\nloss, and transform the patterns of previous ecological conservation and restoration directed by a single target or to single ecological element, which were lacking in holistic and systematic approach, Chinese President Xi Jinping and the Chinese government have put forward the concept that “mountains, rivers, forests, farmland, lakes and grasslands are a community of life”, calling for holistic conservation, systematic restoration and integrated governance of ecosystems. The Ministry of Finance, the Ministry of Natural Resources, and\nthe Ministry of Ecology and Environment of China jointly launched the Initiative of Integrated Ecological Conservation and Restoration of Mountains, Rivers, Forests, Farmland, Lakes, Grasslands and Deserts (“Shan-Shui Initiative” for short,“Shan-Shui” represents “mountains and rivers” in Chinese), upon the approval from the State Council in 2016. 2. Measures 2.1 Establish a territorial spatial planning system A scientific and efficient territorial spatial planning system has been established, to coordinate the layout of ecological, agricultural, urban and other functional zones. The Ecological Conservation Redlines, permanent fundamental farmlands, and urban development boundaries are delineated, as well as the protection lines for marine space. The central government has promulgated the Master Plan for Major Projects of Conservation and Restoration of Nationwide Key Ecosystems (2021-2035) (Annex.2), which defines the overall spatial layout and priorities, featuring with “Three Regions and Four Belts” (details in Annex.1). Provincial-level plans for ecological restoration have been developed, and 1/3 have been released. 2.2 Set up special funds and mobilize private investment The central government has invested USD 1.6 billion\neach year since 2016 to support the projects under the Shan-Shui Initiative, which shall meet the following criteria: 1) Comply with the national territorial spatial planning and the special plans for ecological conservation and restoration; 2) Formulate project implementation plans at the landscape and watershed scale or larger scale with quantifiable and assessable performance indicators; 3)The implementation scope should include ecological space, and\nrelated agricultural and urban space; 4)Activities such as land use pattern and intensity adjustment, flood regulation, disaster prevention, and pollution control, should be implemented, reducing the threats of ecosystem. Biodiversity conservation shall be a major goal; 5)Take into account the employment and livelihoods of the communities and villagers; 6)The total amount of local public and private investment generated should be no less than 1.5 times of the amount of the central government investment; 7)Establish a cross-sector\nmechanism for better organization and coordination and integrate multidisciplinary knowledge and local experience into the projects; 8)Establish a monitoring system at different scales, and adaptive management & post-management mechanism. The Opinions of the General Office of the State Council on Encouraging and Supporting the Involvement of Private Capital in Ecological Conservation and Restoration (Annex.3) was issued by Chinese government to diversify the financing. 2.3 Put in place a series of standards A “1+N” system of technical standards for the Shan-Shui Initiative has been developing. It guides practitioners to follow the laws of natural ecosystem succession and intrinsic mechanisms, take into account the integrity, systemic nature and correlation of natural ecological elements, and implement projects for the ecosystems that are damaged, degraded, or with declining services and functions. Besides, in order to mainstream the Shan-Shui Initiative, Chinese government has listed it in many important plans and documents, such as 14th\nFive-Year Plan for Economics and Social Development.",
        "website": "",
        "startingYear": "2016",
        "endingYear": "",
        "objectives": [],
        "organizations": [
          "Ministry of Natural Resources of China"
        ],
        "targetArea": {
          "units": "ha",
          "value": 10000000
        },
        "areaUnderRestoration": "",
        "keywords": [
          "Flagship"
        ],
        "pointsOfContact": [
          "China Land Consolidation and Rehabilitation"
        ],
        "indicators": [],
        "results": [],
        "ecosystems": [
          "i.T1 Tropical-subtropical forests biome",
          "iii.T3 Shrublands and shrubby woodlands biome",
          "v.T5 Deserts and semi-deserts biome",
          "iii.MT3 Anthropogenic shorelines biome",
          "i.MFT1 Brackish tidal biome",
          "vii.T7 Intensive land-use biome",
          "ii.T2 Temperate-boreal forests and woodlands biome",
          "iv.M4 Anthropogenic marine biome",
          "iii.F3 Artificial wetlands biome",
          "ii.F2 Lakes biome",
          "i.F1 Rivers and streams biome",
          "i.TF1 Palustrine wetlands biome",
          "i.MT1 Shorelines biome",
          "ii.MT2 Supralittoral coastal biome"
        ],
        "restorationTypes": [],
        "tenureStatuses": []
      },
      {
        "id": "KrLkUSFfprfL93zMUltY",
        "title": "Altyn Dala Conservation Initiative",
        "description": "Kazakhstan is home to a great diversity of natural habitats: wetlands; forests; mountains; as well as semi-desert and deserts. However, it is steppe grasslands for which the country is most recognised. These vast grassland ecosystems hold important carbon stocks and support large herds of migratory ungulates and a far wider diversity of resident and migratory species.\n\nKazakhstan supports >95% of the global population of saiga antelope, which acts as the keystone species. Today, grasslands represent the least protected terrestrial habitat globally, and nearly a half of the global grassland area has been degraded by conversion for agriculture, fragmentation, development, or chronic overgrazing. Climate change is becoming an additional significant driver, and targeted poaching continues to threaten key species’ populations, especially the saiga antelope. The Altyn Dala Conservation Initiative is a large-scale, long-term effort to conserve and restore fully functional ecosystems of steppe, semi-desert and desert across the historical range of the saiga antelope in Kazakhstan, spanning 750,000 km².\n\nIt is spearheaded in Kazakhstan by ACBK, with financial and technical assistance from FFI, FZS, and the RSPB, working in partnership with the Government of Kazakhstan’s Committee for Forestry & Wildlife, part of the Ministry of Ecology, Geology & Natural Resources.\n\nOur specific goals include:\nConserve and restore the ecosystems of the steppe, semi-desert and desert within the formal distribution range of saiga antelopes in Kazakhstan as unique ecological systems supporting their historical inventory of animal and plant species. \n\nSupport the Government of Kazakhstan in meeting its obligations in relation to species recovery and protected area management under the Convention on Biological Diversity, Convention on Migratory Species, Convention on International Trade in Endangered Species of Wild Fauna and Flora, and the Ramsar Convention on Wetlands of International Importance especially Waterfowl Habitats. \n\nRestore the populations of saiga antelope in Kazakhstan by researching saiga ecology and monitoring populations, raising awareness among key stakeholders, supporting anti-poaching efforts and combating illegal international trade in saiga horn, and exploring potential for its sustainable use. \n\nDemonstrate with scientific evidence the value and benefits of integrated landscape scale habitat and species management, combining state protected areas, other effective area-based conservation measures (OECMs), and ecological corridors to support national conservation objectives. \n\nGenerate socio-economic benefits and share knowledge gained through implementing the Initiative from local steppe communities to global efforts to conserve grassland ecosystems.\n\nKey achievements of the Altyn Dala Conservation Initiative since 2005 relating to restoration include: \ndeveloped and enacted new national legislation to enable habitat protection for biodiversity, notably establishing the legal basis for Ecological Corridors and Important Bird Areas; provided scientific evidence for the establishment of nearly 5 million hectares of new state protected areas; enabled recovery of saiga antelope populations from <50,000 in 2006 to over 840,000 in 2021; collected data on saiga migration since 2009, which resulted in 193 collared animals and enabled successful advocacy for the removal of barriers to migration in Ustyurt (please see example below) as well as the halting of damaging road development through key saiga habitat; using saiga telemetry data, created opportunities for saiga migration on the Ustyurt plateau through 1) successfully advocating for the removal of a bottom section of the barbed wire in border fencing; and 2) through the creation of railway crossings; translocation of Asiatic wild ass in 2017; created additional employment of 10 reserve staff in Kazakhstan",
        "website": "https://altyndala.org/",
        "startingYear": "2006",
        "endingYear": "",
        "objectives": [
          "Improve biodiversity",
          "Contribute to climate change adaptation and mitigation"
        ],
        "organizations": [
          "Association for the Conservation of Biodiversity in Kazakhstan",
          "Forestry and Wildlife Committee of Ministry of Ecology, Geology and Natural Resources of the Republic of Kazakhstan",
          "Flora and Fauna International",
          "Frankfurt Zoological Society",
          "Royal Society for the Protection of Birds"
        ],
        "targetArea": "",
        "areaUnderRestoration": 5000000,
        "keywords": [
          "Flagship"
        ],
        "pointsOfContact": [
          "Cambridge Conservation Initiative"
        ],
        "indicators": [],
        "results": [],
        "ecosystems": [
          "iii.T3 Shrublands and shrubby woodlands biome",
          "v.T5 Deserts and semi-deserts biome",
          "i.F1 Rivers and streams biome",
          "i.TF1 Palustrine wetlands biome",
          "iv.T4 Savannas and grasslands biome"
        ],
        "restorationTypes": [],
        "tenureStatuses": []
      },
      {
        "id": "bnmZlIFA7jezj0zAOkh0",
        "title": "Namami Gange",
        "description": "In India, the River Ganga (National River of India) holds special significance, as it is not just a river but embodies the collective sentiments, conscious and faith of the people. In 2015, the Namami Gange mission, under the Ministry of Jal Shakti, Government of India was launched for the protection, conservation and rejuvenation of the Ganga River basin. The program has been allocated a total budget of USD 4.25 billion, (including Namami Gange 2.0). The National Mission for Clean Ganga is the implementing body of the mission and was given special powers in the 2016 Authority notification under Environment Protection Act’ 1986. Spread across a quarter of India’s landmass, approximately 520 million citizens reside in the Ganga basin and contribute over 40% to the nation’s GDP. Guided by a holistic approach, the focus of the mission has been on the riverine ecosystem, including components such as pollution abatement, solid and liquid waste management, biodiversity, afforestation, wetland conservation, agribusiness, groundwater management, etc. The mission is based on the four pillars - Nirmal Ganga (Unpolluted Flow), Aviral Ganga (Unrestricted Flow), Jan Ganga (People River Connect) and Gyan Ganga (Research and Knowledge Management). The concerted efforts of the Mission has culminated into several achievements in a very short period of time which include the sanction of creation of over 5024 MLD sewerage treatment capacity in the Ganga basin, improvement in water quality especially up till Haridwar in the northern state of Uttarakhand wherein it has reached class A standard (highest quality), transformation of the mission into a Jan Andolan (People’s Movement) through active public participation, promotion of sustainable agricultural practices especially natural farming, increase in number of species like Hilsa, Gangetic Dolphins, Turtles, Otters, etc. The model is based on the symbiotic relationship between nature-society and aims to strengthen the people-river connect. Several multi-sectoral interventions ranging from promotion of natural farming to livelihood interventions, are to be achieved through synergies at different institutional levels, coupled with adoption of decentralized governance practices. The model strives to improve the quality of life of people in Ganga Basin through sustainable economic development and strengthened people-river connect.",
        "website": "https://nmcg.nic.in",
        "startingYear": "2015",
        "endingYear": "",
        "objectives": [],
        "organizations": [
          "National Mission for Clean Ganga, Ministry of Jal Shakti, Government of India",
          "World Bank",
          "UN Habitat",
          "World Wild Fund for Nature",
          "United Nations Environment Programme",
          "World Resources Institute",
          "Deutsche Gesellschaft für Internationale Zusammenarbeit"
        ],
        "targetArea": "",
        "areaUnderRestoration": "",
        "keywords": [
          "Flagship"
        ],
        "pointsOfContact": [
          "National Mission for Clean Ganga, Ministry of Jal Shakti, Government of India"
        ],
        "indicators": [],
        "results": [],
        "ecosystems": [
          "i.T1 Tropical-subtropical forests biome",
          "iii.T3 Shrublands and shrubby woodlands biome",
          "vii.T7 Intensive land-use biome",
          "iii.F3 Artificial wetlands biome",
          "ii.F2 Lakes biome",
          "i.F1 Rivers and streams biome",
          "i.TF1 Palustrine wetlands biome"
        ],
        "restorationTypes": [],
        "tenureStatuses": []
      },
      {
        "id": "jdU9JFJpR4HHGl1h87SK",
        "title": " Building with Nature in Indonesia - restoring an eroding coastline and inspiring action at scale",
        "description": "The flagship is a landscape scale implementation of the Building with Nature approach between 2015 and 2021 in Demak, adopted after the construction of seawalls and the planting of mangroves failed to stop the loss of land. Demak is a low-lying coastal district in Central Java, plagued by erosion, flooding and land loss. This is caused by the removal of a protective belt of mangroves for aquaculture ponds, land subsidence, river engineering and ill-judged hard infrastructure that disrupt the sediment and water flows. Rising sea levels and increasing storm surges further put the people of Demak and another 30 mln people in Java alone at risk of flooding, salt water invasion and large scale erosion.\n\nThe flagship delivered several technical solutions. One novel technology has been the placement of 9km of mud-trapping semi-permeable structures along the seaward edge to prevent further erosion of the 20km coastline. The structures slow down waves and allow mud to settle inside the grid. Once the nearshore bed level rises enough, mangroves can regenerate naturally to protect the hinterland from further erosion. The grids have locally stopped erosion, delaying land loss: a big gain for the villagers and promising for those along Northern Java’s shorelines and elsewhere. The structures were largely built by communities and since 2018 they also own them. Unfortunately, land subsidence has limited seaward mangrove restoration close to Semarang. If subsidence can be stopped, lost ground can also be recovered to push out the coastline to where it used to be. But if it continues, the structures can only reduce the land loss temporarily. \n\nThe land subsidence also demonstrated how important it is to restore mangroves in landward direction from the shoreline wherever possible, especially in the face of sea level rise. The flagship supported farmers in the desired coastal greenbelt zone to convert their abandoned and unproductive ponds into mangroves. Sediment was allowed to enter the basins, along with water containing mangrove seeds. In some places specific mangrove species were replanted, but otherwise we allowed natural regeneration. Up to 70% of the pond area landward of the shoreline dedicated to conversion was covered by mangroves by the end of the project.\n\nAlong rivers and creeks, farmers were introduced to the novel ‘associated mangrove aquaculture’ system, a more sustainable alternative to the conventional silvo-fisheries system. Part of the pond is given up to make space for the natural recruitment of riverine mangroves to protect earthen sea walls along rivers and ponds, reduce maintenance costs, and enhance fisheries and water quality. The success rate of mangrove recovery was ~75% and farmers experienced improvements in yields, especially when applying techniques learned at coastal field schools (CFS), in which they learnt practices that preserve and restore the mangrove and require less chemicals.\n\nIn ponds further land inward, the flagship helped revitalise the aquaculture sector in Demak - which lost 60-80% of its income due to erosion, flooding and pollution. Over 80% of the farmers adopted the new practices acquired in CFS in 464 ha of ponds and profit margins tripled. Through the innovative Bio-rights incentive mechanism, communities received financial and technical support to adopt sustainable aquaculture practices and other livelihoods in return for ecosystem restoration activities. \n\nThe flagship supported upscaling  in Indonesia through training, knowledge exchange and institutional embedding. Communities participated in coastal and village planning which already resulted in enhanced government funding for the maintenance of permeable structures, mangrove rehabilitation and improved aquaculture. MMAF has mainstreamed 23,5 kilometres of semi-permeable structures throughout Indonesia. MPWH has tested structure designs and secured funds for impact monitoring. MMAF is core partner in the follow-up BwN Asia initiative.",
        "website": "https://www.ecoshape.org/en/pilots/building-with-nature-indonesia/",
        "startingYear": "2015",
        "endingYear": "2021",
        "objectives": [
          "Reforest degraded lands",
          "Increase food and products production",
          "Contribute to climate change adaptation and mitigation",
          "Improve livelihoods",
          "Other"
        ],
        "organizations": [
          "Wetlands International",
          "Ecoshape",
          "Ministry of Marine Affairs and Fisheries",
          "Ministry of Public Work and Housing",
          "Witteveen+Bos",
          "Deltares",
          "Delft University of Technology",
          "Wageningen University & Research",
          "Blue Forests",
          "Kota Kita",
          "Diponegoro University",
          "Von Lieberman",
          "IHE Delft Institute for Water Education"
        ],
        "targetArea": {
          "value": 440,
          "units": "ha"
        },
        "areaUnderRestoration": "",
        "keywords": [
          "Flagship"
        ],
        "pointsOfContact": [
          "Wetlands International"
        ],
        "indicators": [],
        "results": [],
        "ecosystems": [
          "vii.T7 Intensive land-use biome",
          "i.MT1 Shorelines biome",
          "i.MFT1 Brackish tidal biome"
        ],
        "restorationTypes": [],
        "tenureStatuses": []
      },
      {
        "id": "xYMPZII1Qh8exglK5Tdf",
        "title": "Central America dry corridor Agro-Forestry Restoration",
        "description": "The flagship consists of scaling up of functional landscape restoration in selected territories of the Central American Dry Corridor (CSCA) and the dry arch of Panama, contributing to the implementation of the Restoration Decade according to regional and national commitments.\n\nThe CSCA flagship is the conception of a regional development model based on the sustainable use of land and the conservation of natural resources, stressed by the degradation associated with inappropriate use and the impacts of climate change. The CSCA is based in an active rescue and adaptation of traditional practices linked to production under agroforestry systems that partly resemble the functioning of natural systems and allow the recovery of ecosystem services. Examples of these are the agroforestry systems of cocoa, coffee, cardamom, and other fruit trees; Silvopastoral systems, and; the conservation of forest areas related to the catchment and distribution of water. All this happening in the context of a landscape governed by a series of agreements, formal or not, between the local stakeholders who usufruct the territory. The flagship will promote ongoing initiatives in functional landscapes and their connectivity with key conservation areas (to be determined in the inception phase) in which: a) Existing science-based restoration models will be adjusted (technically, economically, environmentally, and socially) to restoration needs, taking into account the variety of present ecosystems and their interaction with productive systems. b) The political and local governance framework aimed at planning and sustainable use of the productive landscape will be strengthened, including local monitoring of restoration, environmental and social benefits, and its link with national monitoring programs of related global environmental commitments to CBD, UNDDC, and Paris agreements, and the UN Decade’s monitoring and reporting framework. c) Incentives and financial mechanisms for the implementation of restoration actions will be developed, adjusted, adapted and/or created. Evidence will be generated on the benefits of existing incentives and required adjustments (for example PROBOSQUE / Guatemala, Cajas Rurales / Honduras, etc.), and the use of small grants will be promoted through local organizations (cooperatives, producer associations, indigenous peoples) , seeking to leverage public and private resources oriented to productive restoration, and conservation (local NGOs, water user boards, co-managers of protected areas). National and regional development banks (CABEI, BANDESA, BANHPROVI, etc) will be required to analyzed how credit lines u other financial services could contribute to restoration activities (especially those that are already working on mechanisms to finance activities related to compliance with the NDC). The incentives should reduce the risk perception of those ultimately responsible for executing restoration activities and could be economic, financial, knowledge, legal (legal security), fiscal and technical assistance incentives, etc. d) Processes for the adoption of the models generated according to the ecological, social, cultural, and economic conditions in projects and initiatives underway (RECLIMA; RELIVE, AFOLU 2040, GCF of CABEI) will be systematized and developed. The intervention of the flagship will be at 3 levels. Direct intervention in selected areas in the highlands of Guatemala (dept. Quiche) and municipalities of San Miguel in El Salvador, where the restoration models with a landscape approach will be adjusted. An area of indirect intervention through ongoing projects with activities of sustainable production, conservation, and restoration (macro area of intervention where UNEP, FAO, and IUCN implement projects) and finally the area of influence to the lessons learned and the instruments generated that is the entire Central American dry corridor.",
        "website": "http://www.sica.int/cac",
        "startingYear": "",
        "endingYear": "",
        "objectives": [
          "Improve soil health",
          "Increase food and products production",
          "Improve biodiversity",
          "Contribute to climate change adaptation and mitigation",
          "Improve water availability and quality",
          "Improve livelihoods",
          "Ensure sustainability of restoration practices",
          "Enhance ecosystem resilience"
        ],
        "organizations": [
          "Sistema de Integracion Centro Americana ",
          "International Union for Conservation of Nature",
          "United Nations Environment Programme",
          "Food and Agriculture Organization"
        ],
        "targetArea": {
          "units": "ha",
          "value": 100000
        },
        "areaUnderRestoration": "",
        "keywords": [
          "Flagship"
        ],
        "pointsOfContact": [
          "Sistema de Integracion CentroAmericana "
        ],
        "indicators": [
          "SDG_I_2.3.1: Volume of production per labour unit by classes of farming pastoral forestry enterprise size [USD]",
          "SDG_I_2.3.2: Average income of small-scale food producers by sex and indigenous status [USD]",
          "SDG_I_2.4.1: Proportion of agricultural area under productive and sustainable agriculture [%]",
          "SDG_I_2.4.1-4: Prevalence of soil degradation [unknown]",
          "SDG_I_2.4.1-5: Variation in water availability [unknown]",
          "SDG_I_2.4.1-8: Use of agro-biodiversity-supportive practices [unknown]",
          "SDG_I_2.4.1-10: Food Insecurity Experience Scale FIES [unknown]",
          "SDG_I_6.6.1: Change in water-use efficiency over time [Mm3/yr, km2,%]",
          "SDG_I_6.6.1-1: Level of water stress: freshwater withdrawal as a proportion of available freshwater resources [%]",
          "SDG_I_6.6.1-2: Degree of integrated water resources management [unknown]",
          "SDG_I_6.6.1-3: Proportion of transboundary basin area with an operational arrangement for water cooperation [%]",
          "SDG_I_6.6.1-5: Change in the extent of water-related ecosystems over time [%; ha]",
          "SDG_I_13.1.2: Number of countries that adopt and implement national disaster risk reduction strategies in line with the Sendai Framework for Disaster Risk Reduction 2015–2030 [nb]",
          "SDG_I_13.1.3: Proportion of local governments that adopt and implement local disaster risk reduction strategies in line with national disaster risk reduction strategies [%]",
          "SDG_I_14.2.1: Number of countries using ecosystem-based approaches to managing marine areas [unknown]",
          "SDG_I_15.1.1: Forest area as a proportion of total land area [kha, %]",
          "SDG_I_15.1.2: Proportion of important sites for terrestrial and freshwater biodiversity that are covered by protected areas by ecosystem type [%]",
          "SDG_I_15.2.1: Progress towards sustainable forest management [t/ha kha, %]",
          "SDG_I_15.2.1-1: Forest area annual net change rate [ha]",
          "SDG_I_15.2.1-2: Above-ground biomass stock in forest [t/ha]",
          "SDG_I_15.2.1-3: Proportion of forest area located within legally established protected areas [%]",
          "SDG_I_15.2.1-4: Proportion of forest area under a long-term forest management plan [%]",
          "SDG_I_15.2.1-5: Forest area under an independently verified forest management certification scheme [ha]",
          "SDG_I_15.3.1: Proportion of land that is degraded over total land area [%]",
          "SDG_I_15.3.1-1: Trends in Land Cover [unknown]",
          "SDG_I_15.3.1-2: Trends in Land Productivity [unknown]",
          "SDG_I_15.3.1-3: Trends in Carbon Stocks [nb, t/ha, Mg/ha]",
          "SDG_I_15.4.2: Mountain Green Cover Index [nb, km2]"
        ],
        "results": "Partially",
        "ecosystems": [
          "i.T1 Tropical-subtropical forests biome"
        ],
        "restorationTypes": [],
        "tenureStatuses": []
      }
    ]
  end
end
