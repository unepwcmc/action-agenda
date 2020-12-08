class CreateCommitments < ActiveRecord::Migration[5.2]
  def change
    create_table :commitments do |t|
      t.boolean :geographic_boundary
      t.float :latitude
      t.float :longitude
      t.integer :current_area_km
      t.integer :proposed_area_km
      t.integer :committed_year
      t.integer :implementation_year
      t.integer :update_year
      t.text :name
      t.text :governance_authority
      t.text :planned_actions
      t.text :description
      t.string :link

      t.timestamps
    end
  end
end
