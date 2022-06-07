desc 'Reassign Commitments to correct managers and remove duplicated manager types'
task reassign_commitments_to_correct_managers: :environment do
  reassign_records('Non-profit organisation', 'Non-governmental organisation (NGO)')
  reassign_records('For-profit organisation', 'For-profit organisation (business and industry)')
  reassign_records('Joint governance', 'Joint governance (i.e. decisions are made by many)')
  Manager.find_by(name: 'Collaborative governance (i.e. decisions are made by one group on behalf of many)').update(name: 'Collaborative governance')
end

def reassign_records(remove_from_string, assign_to_string)
  remove_from = Manager.find_by(name: remove_from_string)
  assign_to = Manager.find_by(name: assign_to_string)
  CommitmentsManager.where(manager_id: remove_from.id).update_all(manager_id: assign_to.id)
  remove_from.destroy
  assign_to.update(name: remove_from_string)
end
