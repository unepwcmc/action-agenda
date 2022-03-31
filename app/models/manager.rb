class Manager < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Local communities',
    'Indigenous peoples',
    'Non-governmental organisation',
    'For-profit organisation',
    'Sub-national government',
    'Joint governance',
    'Individual landowners',
    'Collaborative governance',
    'Other'
  ]

  scope :commitment_form_options, -> { where("default_option IS true AND name != 'None of the above'") }
  scope :filter_options, -> { where("default_option IS true AND name != 'Sub-national government'") }
  
  has_and_belongs_to_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name

end
