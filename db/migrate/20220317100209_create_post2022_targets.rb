class CreatePost2022Targets < ActiveRecord::Migration[5.2]
  def change
    create_table :post2020_targets do |t|
      t.string :name, unique: true, null: false

      t.timestamps
    end

    create_table :post2020_targets_commitment_activities do |t|
      t.belongs_to :post2020_target, index: true, null: false, index: { name: "post2020_activities_targets"}
      t.belongs_to :commitment_activity, polymorphic: true, index: true, null: false, index: { name: "targets_post2020_activities"}

      t.timestamps
    end
  end
end
