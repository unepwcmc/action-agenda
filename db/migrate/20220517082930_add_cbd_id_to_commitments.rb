class AddCbdIdToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :cbd_id, :string, null: true
    add_index :commitments, :cbd_id, unique: true
  end
end
