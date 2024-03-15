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
        puts "Error importing or updating FERM initiative #{initiative_hash[:id]}: #{e.message}"
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
    HTTParty.get(INITIATIVES_URL)
#     [
#   {
#     "id": "AZyE1n1yoXh2fWwWcICz",
#     "title": "1 MILLION HECTARS FOR HERITAGE TREES",
#     "description": "Our initiative in Estonia recruits new landowners each year to participate in voluntary conservation pledge to keep heritage trees reaching circumference more then 220 cm The key aspect of our intervention is to boost the owner’s willingness to participate voluntarily in conservation action, that may lead in the future for bigger commitments. It is both - direct action to hold microhabitats and the peace offering to nature conservation and landowners quarrels.",
#     "website": "https://www.loodushoiufond.ee/polispuu",
#     "starting_date": "2022-05-11",
#     "ending_date": "2027-05-11",
#     "target_area": 800000,
#     "total_area_under_restoration": 121770,
#     "areas_unit": "ha",
#     "objectives": [
#       "Improve biodiversity",
#       "Ensure/protect rights and culture",
#       "Contribute to climate change adaptation and mitigation",
#       "Improve livelihoods"
#     ],
#     "organizations": [
#       {
#         "name": "The Nature Fund",
#         "type": "NGO"
#       }
#     ],
#     "keywords": [
#       "biodiversity",
#       "heritage trees",
#       "cultural heritage"
#     ],
#     "points_of_contact": [
#       "The Nature Fund"
#     ],
#     "country_codes": [
#       "EE"
#     ],
#     "country_names": [
#       "Estonia"
#     ],
#     "activities": [
#       "Social and environmental impact assessments",
#       "Development of guidance and course materials",
#       "Private and community-based conservation"
#     ],
#     "ecosystems": [
#       "T2 - Temperate-boreal forests and woodlands biome"
#     ],
#     "restoration_types": [
#       "Ecological restoration"
#     ],
#     "tenure_statuses": [
#       "Other"
#     ],
#     "contribution_to_sdg": [
#       {
#         "goal": "15",
#         "description": "Goal 15. Protect, restore and promote sustainable use of terrestrial ecosystems, sustainably manage forests, combat desertification, and halt and reverse land degradation and halt biodiversity loss"
#       }
#     ],
#     "best_practices_ids": [
#       "W8yIawsrllZwlxHwpfoE"
#     ]
#   },
#   {
#     "id": "Eq02MtGXWtHMRTbcxEUU",
#     "title": "Restoration of the damaged area between Baekdudaegan Mountain Range   (Gimcheon Baramjae)",
#     "description": "Baekdudaegan Mountain Range refers to the mountain range from Baekdusan\nMountain to Jirisan Mountain, and is not only the natural and human foundation of the Korean Peninsula, but also the core ecological axis of Korea, which is highly symbolic of the forest ecosystem.\nRestoration of the damaged land, which was damaged by the construction of military facilities and access roads in Baekdudaegan, a key ecological axis, was promoted to promote diversity in the forest ecosystem",
#     "website": "https://english.forest.go.kr/kfsweb/kfs/subIdx/Index.do?mn=UENG",
#     "starting_date": "",
#     "ending_date": "",
#     "target_area": 6,
#     "total_area_under_restoration": 6,
#     "areas_unit": "ha",
#     "objectives": [],
#     "organizations": [
#       {
#         "name": "Korea Forest Service",
#         "type": "Government"
#       }
#     ],
#     "keywords": [
#       "Baekdudaegan"
#     ],
#     "points_of_contact": [
#       "Korea Forest Service"
#     ],
#     "country_codes": [
#       "KR"
#     ],
#     "country_names": [
#       "Republic of Korea"
#     ],
#     "activities": [
#       "Legal and rights-based instruments",
#       "Soil and water management",
#       "Control of invasive species",
#       "Restoration of vegetation cover"
#     ],
#     "ecosystems": [
#       "T2 - Temperate-boreal forests and woodlands biome"
#     ],
#     "restoration_types": [
#       "Ecological restoration"
#     ],
#     "tenure_statuses": [
#       "Government"
#     ],
#     "contribution_to_sdg": [
#       {
#         "goal": "15",
#         "description": "Goal 15. Protect, restore and promote sustainable use of terrestrial ecosystems, sustainably manage forests, combat desertification, and halt and reverse land degradation and halt biodiversity loss"
#       }
#     ],
#     "best_practices_ids": []
#   },
#   {
#     "id": "KrLkUSFfprfL93zMUltY",
#     "title": "Altyn Dala Conservation Initiative",
#     "description": "Kazakhstan is home to a great diversity of natural habitats: wetlands; forests; mountains; as well as semi-desert and deserts. However, it is steppe grasslands for which the country is most recognised. These vast grassland ecosystems hold important carbon stocks and support large herds of migratory ungulates and a far wider diversity of resident and migratory species.\n\nKazakhstan supports >95% of the global population of saiga antelope, which acts as the keystone species. Today, grasslands represent the least protected terrestrial habitat globally, and nearly a half of the global grassland area has been degraded by conversion for agriculture, fragmentation, development, or chronic overgrazing. Climate change is becoming an additional significant driver, and targeted poaching continues to threaten key species’ populations, especially the saiga antelope. The Altyn Dala Conservation Initiative is a large-scale, long-term effort to conserve and restore fully functional ecosystems of steppe, semi-desert and desert across the historical range of the saiga antelope in Kazakhstan, spanning 750,000 km².\n\nIt is spearheaded in Kazakhstan by ACBK, with financial and technical assistance from FFI, FZS, and the RSPB, working in partnership with the Government of Kazakhstan’s Committee for Forestry & Wildlife, part of the Ministry of Ecology, Geology & Natural Resources.\n\nOur specific goals include:\nConserve and restore the ecosystems of the steppe, semi-desert and desert within the formal distribution range of saiga antelopes in Kazakhstan as unique ecological systems supporting their historical inventory of animal and plant species. \n\nSupport the Government of Kazakhstan in meeting its obligations in relation to species recovery and protected area management under the Convention on Biological Diversity, Convention on Migratory Species, Convention on International Trade in Endangered Species of Wild Fauna and Flora, and the Ramsar Convention on Wetlands of International Importance especially Waterfowl Habitats. \n\nRestore the populations of saiga antelope in Kazakhstan by researching saiga ecology and monitoring populations, raising awareness among key stakeholders, supporting anti-poaching efforts and combating illegal international trade in saiga horn, and exploring potential for its sustainable use. \n\nDemonstrate with scientific evidence the value and benefits of integrated landscape scale habitat and species management, combining state protected areas, other effective area-based conservation measures (OECMs), and ecological corridors to support national conservation objectives. \n\nGenerate socio-economic benefits and share knowledge gained through implementing the Initiative from local steppe communities to global efforts to conserve grassland ecosystems.\n\nKey achievements of the Altyn Dala Conservation Initiative since 2005 relating to restoration include: \ndeveloped and enacted new national legislation to enable habitat protection for biodiversity, notably establishing the legal basis for Ecological Corridors and Important Bird Areas; provided scientific evidence for the establishment of nearly 5 million hectares of new state protected areas; enabled recovery of saiga antelope populations from <50,000 in 2006 to over 840,000 in 2021; collected data on saiga migration since 2009, which resulted in 193 collared animals and enabled successful advocacy for the removal of barriers to migration in Ustyurt (please see example below) as well as the halting of damaging road development through key saiga habitat; using saiga telemetry data, created opportunities for saiga migration on the Ustyurt plateau through 1) successfully advocating for the removal of a bottom section of the barbed wire in border fencing; and 2) through the creation of railway crossings; translocation of Asiatic wild ass in 2017; created additional employment of 10 reserve staff in Kazakhstan",
#     "website": "https://altyndala.org/",
#     "starting_date": "",
#     "ending_date": "",
#     "target_area": {},
#     "total_area_under_restoration": 5000000,
#     "areas_unit": null,
#     "objectives": [
#       "Improve biodiversity",
#       "Contribute to climate change adaptation and mitigation"
#     ],
#     "organizations": [
#       {
#         "name": "Association for the Conservation of Biodiversity in Kazakhstan",
#         "type": "NGO"
#       },
#       {
#         "name": "Forestry and Wildlife Committee of Ministry of Ecology, Geology and Natural Resources of the Republic of Kazakhstan",
#         "type": "Government"
#       },
#       {
#         "name": "Flora and Fauna International",
#         "type": "NGO"
#       },
#       {
#         "name": "Frankfurt Zoological Society",
#         "type": "NGO"
#       },
#       {
#         "name": "Royal Society for the Protection of Birds",
#         "type": "NGO"
#       }
#     ],
#     "keywords": [
#       "Flagship"
#     ],
#     "points_of_contact": [
#       "Cambridge Conservation Initiative"
#     ],
#     "country_codes": [
#       "KZ"
#     ],
#     "country_names": [
#       "Kazakhstan"
#     ],
#     "activities": [
#       "On-site trainings",
#       "Integrated planning and management",
#       "Establishment of protected areas",
#       "Online trainings"
#     ],
#     "ecosystems": [
#       "TF1 - Palustrine wetlands biome",
#       "F1 - Rivers and streams biome",
#       "T4 - Savannas and grasslands biome",
#       "T5 - Deserts and semi-deserts biome",
#       "T3 - Shrublands and shrubby woodlands biome"
#     ],
#     "restoration_types": [],
#     "tenure_statuses": [],
#     "contribution_to_sdg": [],
#     "best_practices_ids": []
#   },
#   {
#     "id": "bnmZlIFA7jezj0zAOkh0",
#     "title": "Namami Gange",
#     "description": "In India, the River Ganga (National River of India) holds special significance, as it is not just a river but embodies the collective sentiments, conscious and faith of the people. In 2015, the Namami Gange mission, under the Ministry of Jal Shakti, Government of India was launched for the protection, conservation and rejuvenation of the Ganga River basin. The program has been allocated a total budget of USD 4.25 billion, (including Namami Gange 2.0). The National Mission for Clean Ganga is the implementing body of the mission and was given special powers in the 2016 Authority notification under Environment Protection Act’ 1986. Spread across a quarter of India’s landmass, approximately 520 million citizens reside in the Ganga basin and contribute over 40% to the nation’s GDP. Guided by a holistic approach, the focus of the mission has been on the riverine ecosystem, including components such as pollution abatement, solid and liquid waste management, biodiversity, afforestation, wetland conservation, agribusiness, groundwater management, etc. The mission is based on the four pillars - Nirmal Ganga (Unpolluted Flow), Aviral Ganga (Unrestricted Flow), Jan Ganga (People River Connect) and Gyan Ganga (Research and Knowledge Management). The concerted efforts of the Mission has culminated into several achievements in a very short period of time which include the sanction of creation of over 5024 MLD sewerage treatment capacity in the Ganga basin, improvement in water quality especially up till Haridwar in the northern state of Uttarakhand wherein it has reached class A standard (highest quality), transformation of the mission into a Jan Andolan (People’s Movement) through active public participation, promotion of sustainable agricultural practices especially natural farming, increase in number of species like Hilsa, Gangetic Dolphins, Turtles, Otters, etc. The model is based on the symbiotic relationship between nature-society and aims to strengthen the people-river connect. Several multi-sectoral interventions ranging from promotion of natural farming to livelihood interventions, are to be achieved through synergies at different institutional levels, coupled with adoption of decentralized governance practices. The model strives to improve the quality of life of people in Ganga Basin through sustainable economic development and strengthened people-river connect.",
#     "website": "https://nmcg.nic.in",
#     "starting_date": "",
#     "ending_date": "",
#     "target_area": {},
#     "total_area_under_restoration": null,
#     "areas_unit": null,
#     "objectives": [],
#     "organizations": [
#       {
#         "name": "National Mission for Clean Ganga, Ministry of Jal Shakti, Government of India",
#         "type": "Government"
#       },
#       {
#         "name": "World Bank",
#         "type": ""
#       },
#       {
#         "name": "UN Habitat",
#         "type": ""
#       },
#       {
#         "name": "World Wild Fund for Nature",
#         "type": ""
#       },
#       {
#         "name": "United Nations Environment Programme",
#         "type": ""
#       },
#       {
#         "name": "World Resources Institute",
#         "type": ""
#       },
#       {
#         "name": "Deutsche Gesellschaft für Internationale Zusammenarbeit",
#         "type": ""
#       }
#     ],
#     "keywords": [
#       "Flagship"
#     ],
#     "points_of_contact": [
#       "National Mission for Clean Ganga, Ministry of Jal Shakti, Government of India"
#     ],
#     "country_codes": [
#       "IN"
#     ],
#     "country_names": [
#       "India"
#     ],
#     "activities": [
#       "Promotion of sustainable forest management practices",
#       "Training of trainers",
#       "Promotion of indigenous and local knowledge-based traditional use",
#       "Control of point and non-point pollution sources",
#       "Assisted natural regeneration",
#       "Increase diversity and vegetative cover in production systems",
#       "Improved irrigation and water use efficiency",
#       "On-site trainings",
#       "Private and community-based conservation",
#       "Social and environmental impact assessments",
#       "Tree planting",
#       "Wetland construction or rehabilitation",
#       "Online trainings",
#       "Agroforestry",
#       "Participatory natural resource management and governance",
#       "Development of guidance and course materials",
#       "Community consultations"
#     ],
#     "ecosystems": [
#       "TF1 - Palustrine wetlands biome",
#       "F1 - Rivers and streams biome",
#       "T1 - Tropical-subtropical forests biome",
#       "T3 - Shrublands and shrubby woodlands biome",
#       "F2 - Lakes biome",
#       "T7 - Intensive land-use biome",
#       "F3 - Artificial wetlands biome"
#     ],
#     "restoration_types": [],
#     "tenure_statuses": [],
#     "contribution_to_sdg": [],
#     "best_practices_ids": []
#   },
#   {
#     "id": "jdU9JFJpR4HHGl1h87SK",
#     "title": " Building with Nature in Indonesia - restoring an eroding coastline and inspiring action at scale",
#     "description": "The flagship is a landscape scale implementation of the Building with Nature approach between 2015 and 2021 in Demak, adopted after the construction of seawalls and the planting of mangroves failed to stop the loss of land. Demak is a low-lying coastal district in Central Java, plagued by erosion, flooding and land loss. This is caused by the removal of a protective belt of mangroves for aquaculture ponds, land subsidence, river engineering and ill-judged hard infrastructure that disrupt the sediment and water flows. Rising sea levels and increasing storm surges further put the people of Demak and another 30 mln people in Java alone at risk of flooding, salt water invasion and large scale erosion.\n\nThe flagship delivered several technical solutions. One novel technology has been the placement of 9km of mud-trapping semi-permeable structures along the seaward edge to prevent further erosion of the 20km coastline. The structures slow down waves and allow mud to settle inside the grid. Once the nearshore bed level rises enough, mangroves can regenerate naturally to protect the hinterland from further erosion. The grids have locally stopped erosion, delaying land loss: a big gain for the villagers and promising for those along Northern Java’s shorelines and elsewhere. The structures were largely built by communities and since 2018 they also own them. Unfortunately, land subsidence has limited seaward mangrove restoration close to Semarang. If subsidence can be stopped, lost ground can also be recovered to push out the coastline to where it used to be. But if it continues, the structures can only reduce the land loss temporarily. \n\nThe land subsidence also demonstrated how important it is to restore mangroves in landward direction from the shoreline wherever possible, especially in the face of sea level rise. The flagship supported farmers in the desired coastal greenbelt zone to convert their abandoned and unproductive ponds into mangroves. Sediment was allowed to enter the basins, along with water containing mangrove seeds. In some places specific mangrove species were replanted, but otherwise we allowed natural regeneration. Up to 70% of the pond area landward of the shoreline dedicated to conversion was covered by mangroves by the end of the project.\n\nAlong rivers and creeks, farmers were introduced to the novel ‘associated mangrove aquaculture’ system, a more sustainable alternative to the conventional silvo-fisheries system. Part of the pond is given up to make space for the natural recruitment of riverine mangroves to protect earthen sea walls along rivers and ponds, reduce maintenance costs, and enhance fisheries and water quality. The success rate of mangrove recovery was ~75% and farmers experienced improvements in yields, especially when applying techniques learned at coastal field schools (CFS), in which they learnt practices that preserve and restore the mangrove and require less chemicals.\n\nIn ponds further land inward, the flagship helped revitalise the aquaculture sector in Demak - which lost 60-80% of its income due to erosion, flooding and pollution. Over 80% of the farmers adopted the new practices acquired in CFS in 464 ha of ponds and profit margins tripled. Through the innovative Bio-rights incentive mechanism, communities received financial and technical support to adopt sustainable aquaculture practices and other livelihoods in return for ecosystem restoration activities. \n\nThe flagship supported upscaling  in Indonesia through training, knowledge exchange and institutional embedding. Communities participated in coastal and village planning which already resulted in enhanced government funding for the maintenance of permeable structures, mangrove rehabilitation and improved aquaculture. MMAF has mainstreamed 23,5 kilometres of semi-permeable structures throughout Indonesia. MPWH has tested structure designs and secured funds for impact monitoring. MMAF is core partner in the follow-up BwN Asia initiative.",
#     "website": "https://www.ecoshape.org/en/pilots/building-with-nature-indonesia/",
#     "starting_date": "2015-01-01",
#     "ending_date": "2021-12-31",
#     "target_area": 250,
#     "total_area_under_restoration": 235,
#     "areas_unit": "ha",
#     "objectives": [
#       "Contribute to climate change adaptation and mitigation",
#       "Other",
#       "Improve livelihoods",
#       "Increase food and products production",
#       "Reforest degraded lands"
#     ],
#     "organizations": [
#       {
#         "name": "Wetlands International",
#         "type": "NGO"
#       },
#       {
#         "name": "Ecoshape",
#         "type": "NGO"
#       },
#       {
#         "name": "Ministry of Marine Affairs and Fisheries",
#         "type": "Government"
#       },
#       {
#         "name": "Ministry of Public Work and Housing",
#         "type": "Government"
#       },
#       {
#         "name": "Witteveen+Bos",
#         "type": ""
#       },
#       {
#         "name": "Deltares",
#         "type": ""
#       },
#       {
#         "name": "Delft University of Technology",
#         "type": "Academic & research"
#       },
#       {
#         "name": "Wageningen University & Research",
#         "type": "Academic & research"
#       },
#       {
#         "name": "Blue Forests",
#         "type": ""
#       },
#       {
#         "name": "Kota Kita",
#         "type": ""
#       },
#       {
#         "name": "Diponegoro University",
#         "type": "Academic & research"
#       },
#       {
#         "name": "Von Lieberman",
#         "type": ""
#       },
#       {
#         "name": "IHE Delft Institute for Water Education",
#         "type": ""
#       }
#     ],
#     "keywords": [
#       "Flagship",
#       "Mangroves"
#     ],
#     "points_of_contact": [
#       "Wetlands International"
#     ],
#     "country_codes": [
#       "ID"
#     ],
#     "country_names": [
#       "Indonesia"
#     ],
#     "activities": [
#       "Enrichment planting",
#       "Land-use planning (national, regional, local)",
#       "Promotion of indigenous and local knowledge-based traditional use",
#       "Increase diversity and vegetative cover in production systems",
#       "Assisted natural regeneration",
#       "Improvements to land tenure security",
#       "Conservation agriculture",
#       "Incentives for sustainable land-use practices",
#       "Land/water degradation assessment and mapping",
#       "On-site trainings",
#       "Online trainings",
#       "Training of trainers",
#       "Private and community-based conservation",
#       "Participatory natural resource management and governance",
#       "Establishment of protected areas",
#       "Community consultations"
#     ],
#     "ecosystems": [
#       "T7 - Intensive land-use biome",
#       "MT1 - Shorelines biome",
#       "MFT1 - Brackish tidal biome"
#     ],
#     "restoration_types": [],
#     "tenure_statuses": [],
#     "contribution_to_sdg": [
#       {
#         "goal": "06",
#         "description": "Goal 6. Ensure availability and sustainable management of water and sanitation for all"
#       },
#       {
#         "goal": "09",
#         "description": "Goal 9. Build resilient infrastructure, promote inclusive and sustainable industrialization and foster innovation"
#       },
#       {
#         "goal": "11",
#         "description": "Goal 11. Make cities and human settlements inclusive, safe, resilient and sustainable"
#       },
#       {
#         "goal": "12",
#         "description": "Goal 12. Ensure sustainable consumption and production patterns"
#       },
#       {
#         "goal": "13",
#         "description": "Goal 13. Take urgent action to combat climate change and its impacts"
#       },
#       {
#         "goal": "14",
#         "description": "Goal 14. Conserve and sustainably use the oceans, seas and marine resources for sustainable development"
#       },
#       {
#         "goal": "15",
#         "description": "Goal 15. Protect, restore and promote sustainable use of terrestrial ecosystems, sustainably manage forests, combat desertification, and halt and reverse land degradation and halt biodiversity loss"
#       }
#     ],
#     "best_practices_ids": []
#   },
#   {
#     "id": "xYMPZII1Qh8exglK5Tdf",
#     "title": "Central America dry corridor Agro-Forestry Restoration",
#     "description": "The flagship consists of scaling up of functional landscape restoration in selected territories of the Central American Dry Corridor (CSCA) and the dry arch of Panama, contributing to the implementation of the Restoration Decade according to regional and national commitments.\n\nThe CSCA flagship is the conception of a regional development model based on the sustainable use of land and the conservation of natural resources, stressed by the degradation associated with inappropriate use and the impacts of climate change. The CSCA is based in an active rescue and adaptation of traditional practices linked to production under agroforestry systems that partly resemble the functioning of natural systems and allow the recovery of ecosystem services. Examples of these are the agroforestry systems of cocoa, coffee, cardamom, and other fruit trees; Silvopastoral systems, and; the conservation of forest areas related to the catchment and distribution of water. All this happening in the context of a landscape governed by a series of agreements, formal or not, between the local stakeholders who usufruct the territory. The flagship will promote ongoing initiatives in functional landscapes and their connectivity with key conservation areas (to be determined in the inception phase) in which: a) Existing science-based restoration models will be adjusted (technically, economically, environmentally, and socially) to restoration needs, taking into account the variety of present ecosystems and their interaction with productive systems. b) The political and local governance framework aimed at planning and sustainable use of the productive landscape will be strengthened, including local monitoring of restoration, environmental and social benefits, and its link with national monitoring programs of related global environmental commitments to CBD, UNDDC, and Paris agreements, and the UN Decade’s monitoring and reporting framework. c) Incentives and financial mechanisms for the implementation of restoration actions will be developed, adjusted, adapted and/or created. Evidence will be generated on the benefits of existing incentives and required adjustments (for example PROBOSQUE / Guatemala, Cajas Rurales / Honduras, etc.), and the use of small grants will be promoted through local organizations (cooperatives, producer associations, indigenous peoples) , seeking to leverage public and private resources oriented to productive restoration, and conservation (local NGOs, water user boards, co-managers of protected areas). National and regional development banks (CABEI, BANDESA, BANHPROVI, etc) will be required to analyzed how credit lines u other financial services could contribute to restoration activities (especially those that are already working on mechanisms to finance activities related to compliance with the NDC). The incentives should reduce the risk perception of those ultimately responsible for executing restoration activities and could be economic, financial, knowledge, legal (legal security), fiscal and technical assistance incentives, etc. d) Processes for the adoption of the models generated according to the ecological, social, cultural, and economic conditions in projects and initiatives underway (RECLIMA; RELIVE, AFOLU 2040, GCF of CABEI) will be systematized and developed. The intervention of the flagship will be at 3 levels. Direct intervention in selected areas in the highlands of Guatemala (dept. Quiche) and municipalities of San Miguel in El Salvador, where the restoration models with a landscape approach will be adjusted. An area of indirect intervention through ongoing projects with activities of sustainable production, conservation, and restoration (macro area of intervention where UNEP, FAO, and IUCN implement projects) and finally the area of influence to the lessons learned and the instruments generated that is the entire Central American dry corridor.",
#     "website": "http://www.sica.int/cac",
#     "starting_date": "",
#     "ending_date": "",
#     "target_area": 100000,
#     "total_area_under_restoration": null,
#     "areas_unit": "ha",
#     "objectives": [
#       "Improve soil health",
#       "Increase food and products production",
#       "Improve biodiversity",
#       "Contribute to climate change adaptation and mitigation",
#       "Improve livelihoods",
#       "Ensure sustainability of restoration practices",
#       "Enhance ecosystem resilience",
#       "Improve water availability and quality"
#     ],
#     "organizations": [
#       {
#         "name": "Sistema de Integracion Centro Americana ",
#         "type": "Other"
#       },
#       {
#         "name": "International Union for Conservation of Nature",
#         "type": ""
#       },
#       {
#         "name": "United Nations Environment Programme",
#         "type": ""
#       },
#       {
#         "name": "Food and Agriculture Organization",
#         "type": ""
#       }
#     ],
#     "keywords": [
#       "Flagship"
#     ],
#     "points_of_contact": [
#       "Sistema de Integracion CentroAmericana "
#     ],
#     "country_codes": [
#       "CR",
#       "SV",
#       "GT",
#       "HN",
#       "NI",
#       "PA"
#     ],
#     "country_names": [
#       "Nicaragua",
#       "El Salvador",
#       "Costa Rica",
#       "Panama",
#       "Guatemala",
#       "Honduras"
#     ],
#     "activities": [
#       "Conservation and early replacement of topsoil",
#       "Enrichment planting",
#       "Land-use planning (national, regional, local)",
#       "Control of point and non-point pollution sources",
#       "Assisted natural regeneration",
#       "On-site trainings",
#       "Conservation agriculture",
#       "Improved irrigation and water use efficiency",
#       "Incentives for sustainable land-use practices",
#       "Tree planting",
#       "On-site management of mining wastes (soils and water)",
#       "Reclamation of mine site topography",
#       "Online trainings",
#       "Grass planting"
#     ],
#     "ecosystems": [
#       "T1 - Tropical-subtropical forests biome"
#     ],
#     "restoration_types": [],
#     "tenure_statuses": [],
#     "contribution_to_sdg": [
#       {
#         "goal": "13",
#         "description": "Goal 13. Take urgent action to combat climate change and its impacts"
#       },
#       {
#         "goal": "14",
#         "description": "Goal 14. Conserve and sustainably use the oceans, seas and marine resources for sustainable development"
#       },
#       {
#         "goal": "15",
#         "description": "Goal 15. Protect, restore and promote sustainable use of terrestrial ecosystems, sustainably manage forests, combat desertification, and halt and reverse land degradation and halt biodiversity loss"
#       },
#       {
#         "goal": "02",
#         "description": "Goal 2. End hunger, achieve food security and improved nutrition and promote sustainable agriculture"
#       },
#       {
#         "goal": "06",
#         "description": "Goal 6. Ensure availability and sustainable management of water and sanitation for all"
#       }
#     ],
#     "best_practices_ids": []
#   }
# ]
  end

  def categorical_mappings_call
    HTTParty.get(MAPPING_URL)
  end
end
