class AddLatAndLongToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :lat, :float, index: true
    add_column :countries, :long, :float, index: true 
  end
end
