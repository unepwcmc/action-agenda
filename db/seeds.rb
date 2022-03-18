# users
users = [
  { email: 'test@test.com', password: 'password', password_confirmation: 'password' },
  { email: 'test2@test.com', password: 'password', password_confirmation: 'password' },
]
User.create!(users)
User.first.confirm

# Criteria and assicated records
Manager.create!(Manager::DEFAULT_OPTIONS.map {|manager_name| { name: manager_name, default_option: true }})

cbd_objective_names = [ 'Conservation of biological diversity', 'Sustainable use', 'Fair and equitable sharing of benefits from the utilization of genetic resources', 'None of the above' ]
CbdObjective.create!(cbd_objective_names.map {|name| { name: name }})

criteria = [
  { boundary: true, five_year_commitment: true, progress_report: true, managers: [Manager.first], cbd_objectives: [CbdObjective.first], user: User.first },
  { boundary: false, five_year_commitment: true, progress_report: true, managers: [Manager.first], cbd_objectives: [CbdObjective.first], user: User.first },
  { boundary: true, five_year_commitment: false, progress_report: true, managers: [Manager.first], cbd_objectives: [CbdObjective.first], user: User.first },
  { boundary: true, five_year_commitment: true, progress_report: false, managers: [Manager.first], cbd_objectives: [CbdObjective.first], user: User.first },
  { boundary: true, five_year_commitment: true, progress_report: true, managers: [Manager.last], cbd_objectives: [CbdObjective.last], user: User.first },
  { boundary: false, five_year_commitment: false, progress_report: false, managers: [Manager.last], cbd_objectives: [CbdObjective.last], user: User.first }
]
Criterium.create!(criteria)

# Commitments and associated records
Country.import

Action.create!(Action::DEFAULT_OPTIONS.map {|action_name| { name: action_name, default_option: true }})
Threat.create!(Threat::DEFAULT_OPTIONS.map {|threat_name| { name: threat_name, default_option: true }})
Objective.create!(Objective::DEFAULT_OPTIONS.map {|objective_name| { name: objective_name, default_option: true }})

commitments = [
  {
    geographic_boundary: true, latitude: 0.002, longitude: 0.9, current_area_ha: 12, proposed_area_ha: 15, 
    committed_year: 2021, implementation_year: 2022, name: 'A commitment', 
    governance_authority: 'A governance authority name', description: 'A description',
    duration_years: 5, user: User.first, criterium: Criterium.first,
    stage: 'Implemented fully', responsible_group: 'The responsible group', state: 'live',
    threats: Threat.all, actions: Action.all, managers: Manager.all, countries: Country.where(id: 1..5), objectives: Objective.all
  },
  {
    geographic_boundary: true, latitude: 0.002, longitude: 0.9, current_area_ha: 12, proposed_area_ha: 15, 
    committed_year: 2021, implementation_year: 2022, name: 'A commitment', 
    governance_authority: 'A governance authority name', description: 'A description',
    duration_years: 5, user: User.second, criterium: Criterium.first,
    stage: 'Implemented fully', responsible_group: 'The responsible group', state: 'live',
    threats: Threat.all, actions: Action.all, managers: Manager.all, countries: Country.where(id: 1..5), objectives: Objective.all
  }
]
Commitment.create!(commitments)

links = [
  { url: 'something.com', commitment: Commitment.first },
  { url: 'something.org', commitment: Commitment.first }
]
Link.create!(links)