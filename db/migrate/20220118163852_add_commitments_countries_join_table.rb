class AddCommitmentsCountriesJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :commitments_countries, id: false do |t|
      t.belongs_to :commitment
      t.belongs_to :country
    end
  end
end
