class AddUserCreatedToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :user_created, :boolean, null: false, default: false
  end
end
