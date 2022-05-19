class RemoveDurationAndReviewMethodFromCommitments < ActiveRecord::Migration[5.2]
  def change
    remove_column :commitments, :duration, :string
    remove_column :commitments, :review_method, :string
    remove_column :commitments, :proposed_area_ha, :string
  end
end
