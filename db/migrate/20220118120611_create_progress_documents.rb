class CreateProgressDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :progress_documents do |t|
      t.belongs_to :commitment
      t.text :progress_notes

      t.timestamps
    end
  end
end
