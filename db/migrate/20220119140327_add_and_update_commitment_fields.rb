class AddAndUpdateCommitmentFields < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :state, :integer, default: 0
    remove_column :commitments, :update_year, :integer
    remove_column :commitments, :duration, :string
    add_column :commitments, :duration_years, :integer
  end
end
