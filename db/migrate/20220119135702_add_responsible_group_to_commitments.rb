class AddResponsibleGroupToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_column :commitments, :responsible_group, :text
  end
end
