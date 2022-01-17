class CreateObjectives < ActiveRecord::Migration[5.2]
  def change
    create_table :objectives do |t|
      t.string :name

      t.timestamps
    end

    create_table :commitments_objectives, id: false do |t|
      t.belongs_to :commitment
      t.belongs_to :objective
    end
    
    remove_column :commitments, :primary_objectives, :string, {}
  end
end
