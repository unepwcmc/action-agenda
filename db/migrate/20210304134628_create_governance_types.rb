class CreateGovernanceTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :governance_types do |t|
      t.string :name

      t.timestamps
    end
    create_table :commitments_governance_types, id: false do |t|
      t.belongs_to :commitment
      t.belongs_to :governance_type
    end
    remove_column :commitments, :governance_type, :string, {}
  end
end
