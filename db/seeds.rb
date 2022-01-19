# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Criteria and assicated records
stakeholder_names = [ 'Local communities', 'Indigenous peoples', 'Non-governmental organisation (NGO)', 'Private sector (business and industry)', 'Sub-national or local government' ]
Stakeholder.create!(stakeholder_names.map {|name| { name: name }})

cbd_objective_names = [ 'Conservation of biological diversity', 'Sustainable use', 'Fair and equitable sharing of benefits from the utilization of genetic resources' ]
CbdObjective.create!(cbd_objective_names.map {|name| { name: name }})

criteria = [
  { boundary: true, five_year_commitment: true, progress_report: true, stakeholders: [Stakeholder.first], cbd_objectives: [CbdObjective.first] },
  { boundary: false, five_year_commitment: true, progress_report: true, stakeholders: [Stakeholder.first], cbd_objectives: [CbdObjective.first] },
  { boundary: true, five_year_commitment: false, progress_report: true, stakeholders: [Stakeholder.first], cbd_objectives: [CbdObjective.first] },
  { boundary: true, five_year_commitment: true, progress_report: false, stakeholders: [Stakeholder.first], cbd_objectives: [CbdObjective.first] },
  { boundary: true, five_year_commitment: true, progress_report: true, stakeholders: [Stakeholder.last], cbd_objectives: [CbdObjective.last] }
]
Criterium.create!(criteria)

# commitments and associated records
Country.import

manager_names = ['Indigenous peoples', 'Local communities', 'For-profit organisations', 'Non-profit organisations', 'Individual landowners', 'Collaborative governance', 'Joint governance', 'Sub-national ministry or agency', 'Other']
Manager.create!(manager_names.map {|manager_name| { name: manager_name, default_option: true }})

actions =['Land/water protection', 'Land/water management', 'Species management', 'Education & awareness', 'Law & policy', 'Livelihood', 'economic & other incentives' , 'Other']
Action.create!(actions.map {|action_name| { name: action_name }})

threat_names = ['Residential & commercial development', 'Agriculture & aquaculture', 'Energy production & mining', 'Transportation & service corridors', 'Biological resource use', 'Human intrusions & disturbance', 'Natural system modifications', 'Invasive & other problematic species', 'genes & diseases', 'Pollution', 'Geological events', 'Climate change & severe weather', 'Other']
Threat.create!(threat_names.map {|threat_name| { name: threat_name }})

# commitment
# progress_documents
# links
