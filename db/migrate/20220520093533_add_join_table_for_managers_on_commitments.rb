class AddJoinTableForManagersOnCommitments < ActiveRecord::Migration[5.2]
  def change
    create_table :commitments_managers do |t|
      t.belongs_to :commitment
      t.belongs_to :manager
    end

    remove_column :commitments, :manager_id
  end
end
