class AddBoundaryFieldToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :boundary, :geometry, geographic: true

    add_index :countries, :boundary, using: :gist
  end
end
