class AddIsoToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :iso, :string
  end
end
