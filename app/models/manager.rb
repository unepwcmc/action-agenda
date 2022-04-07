class Manager < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Local communities',
    'Indigenous peoples',
    'Non-profit organisation',
    'For-profit organisation',
    'Sub-national government',
    'Joint governance',
    'Individual landowners',
    'Collaborative governance',
    'Other'
  ]

  scope :form_options, -> { where("default_option IS true") }
  scope :filter_options, -> { where("default_option IS true AND name != 'Sub-national government'") }
  
  has_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name

end
