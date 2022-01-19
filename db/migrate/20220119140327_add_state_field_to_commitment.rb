class AddStateFieldToCommitment < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :state, :integer, default: 0 
  end
end
