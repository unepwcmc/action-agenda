class AddCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :criteria do |t|
      t.boolean :boundary, null: false
      t.boolean :five_year_commitment, null: false
      t.boolean :progress_report, null: false

      t.timestamps
    end

    create_table :stakeholders do |t|
      t.string :name

      t.timestamps
    end

    create_table :cbd_objectives do |t|
      t.string :name

      t.timestamps
    end

    create_table :criteria_stakeholders do |t|
      t.belongs_to :criterium
      t.belongs_to :stakeholder

      t.timestamps
    end

    create_table :cbd_objectives_criteria do |t|
      t.belongs_to :criterium
      t.belongs_to :cbd_objective

      t.timestamps
    end
  end
end
