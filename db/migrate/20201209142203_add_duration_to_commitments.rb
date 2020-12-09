class AddDurationToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :duration, :string
  end
end
