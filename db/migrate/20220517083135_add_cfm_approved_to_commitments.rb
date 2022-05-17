class AddCfmApprovedToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :cfm_approved, :boolean, null: true, default: nil
    add_index :commitments, :cfm_approved
  end
end
