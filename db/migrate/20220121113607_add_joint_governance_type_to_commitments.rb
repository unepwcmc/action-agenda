class AddJointGovernanceTypeToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :joint_governance_type, :text
  end
end
