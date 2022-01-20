class Action < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Land/water protection', 'Land/water management', 'Species management', 'Education & awareness',
    'Law & policy', 'Livelihood', 'economic & other incentives' , 'Other'
  ]

  has_and_belongs_to_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name
end