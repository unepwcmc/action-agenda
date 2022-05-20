class ColumnNamesKmToHa < ActiveRecord::Migration[5.2]
  def change
    rename_column :commitments, :current_area_km, :current_area_ha
    rename_column :commitments, :proposed_area_km, :proposed_area_ha
  end
end
