class AddCountryRefToCommitments < ActiveRecord::Migration[5.2]
  def change
    add_reference :commitments, :country, foreign_key: true
  end
end
