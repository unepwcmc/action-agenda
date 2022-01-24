class AddJointGovernanceDescriptionToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :joint_governance_description, :text
  end
end
