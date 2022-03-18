class ReplaceStakeholdersWithManagersOnCriteria < ActiveRecord::Migration[5.2]
  def change
    drop_table :stakeholders
    drop_table :criteria_stakeholders
    remove_column :commitments, :joint_governance_description, :text

    create_table :criteria_managers, id: false do |t|
      t.belongs_to :criterium
      t.belongs_to :manager
    end
  end
end
