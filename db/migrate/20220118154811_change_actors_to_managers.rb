class ChangeActorsToManagers < ActiveRecord::Migration[5.2]
  def change
    rename_table :actors, :managers
    add_column :managers, :default_option, :boolean, default: false
    rename_table :actors_commitments, :commitments_managers
    rename_column :commitments_managers, :actor_id, :manager_id
    add_index(:managers, :name, unique: true)
  end
end
