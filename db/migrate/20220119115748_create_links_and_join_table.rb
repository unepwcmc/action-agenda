class CreateLinksAndJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.text :name
      t.text :url, null: false
      t.belongs_to :commitment

      t.timestamps
    end
  end
end
