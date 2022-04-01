class ChangeManagersToBelongsTo < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :manager_id, :bigint
    add_column :criteria, :manager_id, :bigint
    
    add_index :commitments, :manager_id
    add_index :criteria, :manager_id

    drop_table :commitments_managers
    drop_table :criteria_managers
  end
end
