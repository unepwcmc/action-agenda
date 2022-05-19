class ChangeAreaManagerToAreaOwnerCommitmentsTable < ActiveRecord::Migration[5.2]
  def change
    rename_column :commitments, :area_manager, :area_owner_and_role
  end
end
