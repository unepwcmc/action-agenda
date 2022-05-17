class RemoveUserCreatedFromCommitments < ActiveRecord::Migration[5.2]
  def change
    remove_column :commitments, :user_created, :boolean
  end
end
