class AddCdbImportToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :cbd_import, :boolean, default: 0, null: false
  end
end
