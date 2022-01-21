class CreateThreatsAndJoin < ActiveRecord::Migration[5.2]
  def change
    create_table :threats_and_joins do |t|
      create_table :threats do |t|
        t.text :name, null: false, unique: true
  
        t.timestamps
      end
  
      create_table :commitments_threats do |t|
        t.belongs_to :commitment
        t.belongs_to :threat
      end
    end
  end
end
