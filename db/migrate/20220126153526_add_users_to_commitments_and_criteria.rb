class AddUsersToCommitmentsAndCriteria < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :user_id, :bigint, null: true
    add_column :criteria, :user_id, :bigint, null: false
  end
end
