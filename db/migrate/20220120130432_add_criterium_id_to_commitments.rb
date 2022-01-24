class AddCriteriumIdToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :criterium_id, :bigint, index: true
  end
end
