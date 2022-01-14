# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Criteria and assicated records
stakeholder_names = [ 'Local communities', 'Indiginous peoples', 'Non-governmental organisation (NGO)', 'Priivate sector (business and industry)', 'Sub-national or local government', 'None of the above' ]
Stakeholder.create!(stakeholder_names.map {|name| { name: name }})

cbd_objective_names = [ 'Conservation of biological diversity', 'Sustainable use', 'Fair and equitable sharing of benefits from the utilization of genetic resources', 'None of the above' ]
CbdObjective.create!(cbd_objective_names.map {|name| { name: name }})

criteria = [
  { boundary: true, five_year_commitment: true, progress_report: true, stakeholders: [Stakeholder.first], cbd_objectives: [CbdObjective.first] },
  { boundary: false, five_year_commitment: true, progress_report: true, stakeholders: [Stakeholder.second], cbd_objectives: [CbdObjective.third] },
  { boundary: true, five_year_commitment: false, progress_report: true, stakeholders: [Stakeholder.last], cbd_objectives: [CbdObjective.first] },
  { boundary: true, five_year_commitment: false, progress_report: false, stakeholders: [Stakeholder.first], cbd_objectives: [CbdObjective.last] }
]
Criteria.create!(criteria)
