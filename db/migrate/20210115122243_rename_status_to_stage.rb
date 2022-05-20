class RenameStatusToStage < ActiveRecord::Migration[5.2]
  def change
    rename_column :commitments, :status, :stage
  end
end
