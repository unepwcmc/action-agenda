class AddShareableToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :shareable, :boolean, default: 0, null: true
  end
end
