class AddCbdImportBooleanToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :cbd_import, :boolean, default: 0
    add_index :commitments, :cbd_import
  end
end
