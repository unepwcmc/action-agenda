class CreateActionsAndJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :actions do |t|
      t.text :name, null: false

      t.timestamps
    end

    create_table :actions_commitments do |t|
      t.belongs_to :commitment
      t.belongs_to :action
    end
  end
end
