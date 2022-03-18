class RemoveWebsiteFieldFromUrl < ActiveRecord::Migration[5.2]
  def change
    remove_column :links, :name
  end
end
