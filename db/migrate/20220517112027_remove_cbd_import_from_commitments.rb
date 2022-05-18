class RemoveCbdImportFromCommitments < ActiveRecord::Migration[5.2]
  def change
    remove_column :commitments, :cbd_import, :boolean, default: 0, null: false
  end
end
