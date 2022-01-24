class AddDefaultOptionFieldsToRemainingImportRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :objectives, :default_option, :boolean, default: false
    add_column :actions, :default_option, :boolean, default: false
    add_column :threats, :default_option, :boolean, default: false
  end
end
