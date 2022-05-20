class ChangeDateFieldsToTextOnCommitment < ActiveRecord::Migration[5.2]
  def change
    change_column :commitments, :duration_years, :string
    change_column :commitments, :committed_year, :string
    change_column :commitments, :implementation_year, :string

    add_index :commitments, :duration_years
    add_index :commitments, :committed_year
    add_index :commitments, :implementation_year    
  end
end
