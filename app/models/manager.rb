class Manager < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Local communities', 
    'Indigenous peoples', 
    'Non-governmental organisation (NGO)', 
    'For-profit organisation (business and industry)', 
    'Sub-national government', 
    'Joint governance (i.e. decisions are made by many)', 
    'Individual landowners', 
    'Collaborative governance (i.e. decisions are made by one group on behalf of many)', 
    'Other'
  ]

  scope :commitment_form_options, -> { where("default_option IS true AND name != 'None of the above'") }
  
  has_and_belongs_to_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name

end
