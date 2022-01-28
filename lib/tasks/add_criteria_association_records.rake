desc 'Updates data to match new DB structure'
task add_criteria_association_records: :environment do
  stakeholder_names = [ 'Local communities', 'Indigenous peoples', 'Non-governmental organisation (NGO)', 'Private sector (business and industry)', 'Sub-national or local government', 'None of the above' ]
  Stakeholder.create!(stakeholder_names.map {|name| { name: name }})
  puts 'Stakeholders added'

  cbd_objective_names = [ 'Conservation of biological diversity', 'Sustainable use', 'Fair and equitable sharing of benefits from the utilization of genetic resources', 'None of the above'  ]
  CbdObjective.create!(cbd_objective_names.map {|name| { name: name }})
  puts 'CBD Objectives added'
end