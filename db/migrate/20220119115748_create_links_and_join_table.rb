class CreateLinksAndJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.text :name
      t.text :url, null: false

      t.timestamps
    end
    
    create_table :commitments_links do |t|
      t.belongs_to :commitment
      t.belongs_to :link
    end
  end
end
