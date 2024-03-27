class AddFermIdToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :ferm_id, :string, null: true
    add_index :commitments, :ferm_id, unique: true
  end
end
