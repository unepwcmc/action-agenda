class ChangeStageColumnToOldstageOnCommitments < ActiveRecord::Migration[5.2]
  def change
    rename_column :commitments, :stage, :old_stage
    add_column :commitments, :stage, :integer 
  end
end
