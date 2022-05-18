class AddSourceToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :commitment_source, :integer, index: true
  end
end
