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
  { boundary: true, five_year_commitment: true, progress_report: true, manager: Manager.first, cbd_objectives: [CbdObjective.first], user: User.first },
  { boundary: false, five_year_commitment: true, progress_report: true, manager: Manager.first, cbd_objectives: [CbdObjective.first], user: User.first },
  { boundary: true, five_year_commitment: false, progress_report: true, manager: Manager.first, cbd_objectives: [CbdObjective.first], user: User.first },
  { boundary: true, five_year_commitment: true, progress_report: false, manager: Manager.first, cbd_objectives: [CbdObjective.first], user: User.first },
  { boundary: true, five_year_commitment: true, progress_report: true, manager: Manager.last, cbd_objectives: [CbdObjective.last], user: User.first },
  { boundary: false, five_year_commitment: false, progress_report: false, manager: Manager.last, cbd_objectives: [CbdObjective.last], user: User.first }
]
Criterium.create!(criteria)
