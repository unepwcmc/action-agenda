class Post2020TargetsCommitmentActivity < ApplicationRecord
  belongs_to :post2020_target
  belongs_to :commitment_activity, polymorphic: true
  
  validates_presence_of :post2020_target, :commitment_activity
end
