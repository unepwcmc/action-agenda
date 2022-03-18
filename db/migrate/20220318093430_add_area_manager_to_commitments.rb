class AddAreaManagerToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :area_manager, :text, null: true
  end
end
