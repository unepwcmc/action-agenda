# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Criteria and assicated records
stakeholder_names = [ 'Local communities', 'Indigenous peoples', 'Non-governmental organisation (NGO)', 'Private sector (business and industry)', 'Sub-national or local government', 'None of the above' ]
Stakeholder.create!(stakeholder_names.map {|name| { name: name }})

cbd_objective_names = [ 'Conservation of biological diversity', 'Sustainable use', 'Fair and equitable sharing of benefits from the utilization of genetic resources', 'None of the above' ]
CbdObjective.create!(cbd_objective_names.map {|name| { name: name }})

criteria = [
  { boundary: true, five_year_commitment: true, progress_report: true, stakeholders: [Stakeholder.first], cbd_objectives: [CbdObjective.first] },
  { boundary: false, five_year_commitment: true, progress_report: true, stakeholders: [Stakeholder.first], cbd_objectives: [CbdObjective.first] },
  { boundary: true, five_year_commitment: false, progress_report: true, stakeholders: [Stakeholder.first], cbd_objectives: [CbdObjective.first] },
  { boundary: true, five_year_commitment: true, progress_report: false, stakeholders: [Stakeholder.first], cbd_objectives: [CbdObjective.first] },
  { boundary: true, five_year_commitment: true, progress_report: true, stakeholders: [Stakeholder.last], cbd_objectives: [CbdObjective.last] }
]
Criterium.create!(criteria)

# Commitments and associated records
Country.import

Manager.create!(Manager::DEFAULT_OPTIONS.map {|manager_name| { name: manager_name, default_option: true }})
Action.create!(Action::DEFAULT_OPTIONS.map {|action_name| { name: action_name, default_option: true }})
Threat.create!(Threat::DEFAULT_OPTIONS.map {|threat_name| { name: threat_name, default_option: true }})
Objective.create!(Objective::DEFAULT_OPTIONS.map {|objective_name| { name: objective_name, default_option: true }})

commitments = [
  {
    geographic_boundary: true, latitude: 0.002, longitude: 0.9, current_area_ha: 12, proposed_area_ha: 15, 
    committed_year: 2021, implementation_year: 2022, name: 'A commitment', 
    governance_authority: 'A governance authrity name', description: 'A description', duration_years: 5, 
    stage: 'Implemented', responsible_group: 'The responsible group', state: 'live',
    threats: Threat.all, actions: Action.all, managers: Manager.all, objectives: Objective.all
  }
]
Commitment.create!(commitments)

links = [
  { url: 'something.com', name: 'a website', commitment: Commitment.first },
  { url: 'something.org', name: 'another website', commitment: Commitment.first }
]
Link.create!(links)