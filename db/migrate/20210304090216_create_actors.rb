class CreateActors < ActiveRecord::Migration[5.2]
  def change
    create_table :actors do |t|
      t.string :name

      t.timestamps
    end
    create_table :actors_commitments, id: false do |t|
      t.belongs_to :commitment
      t.belongs_to :actor
    end
    remove_column :commitments, :actor, :string, {}
  end
end
