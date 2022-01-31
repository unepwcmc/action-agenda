class Action < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Land/water protection', 'Land/water management', 'Species management', 'Education & awareness',
    'Law & policy', 'Livelihood', 'Economic & other incentives' , 'Other'
  ]

  scope :commitment_form_options, -> { where(default_option: true) }
  
  has_and_belongs_to_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
