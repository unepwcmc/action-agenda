class AddCfmApprovedToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :cfn_approved, :boolean, null: true, default: nil
    add_index :commitments, :cfn_approved
  end
end
