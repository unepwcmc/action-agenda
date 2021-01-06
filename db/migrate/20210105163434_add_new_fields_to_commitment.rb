class AddNewFieldsToCommitment < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :actor, :string
    add_column :commitments, :governance_type, :string
    add_column :commitments, :related_biodiversity_targets, :string
    add_column :commitments, :primary_objectives, :string
    add_column :commitments, :review_method, :string
  end
end
