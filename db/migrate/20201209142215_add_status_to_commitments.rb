class AddStatusToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :status, :string
  end
end
