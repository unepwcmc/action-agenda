class Manager < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Indigenous peoples', 'Local communities', 'For-profit organisations', 'Non-profit organisations', 'Individual landowners',
    'Collaborative governance', 'Joint governance', 'Sub-national ministry or agency', 'None of the above'
  ]

  scope :commitment_form_options, -> { where("default_option IS true AND name != 'None of the above'") }
  
  has_and_belongs_to_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name

end
