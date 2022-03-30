class Manager < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Local communities', 
    'Indigenous peoples', 
    'Non-profit organisation', 
    'For-profit organisation (business and industry)', 
    'Sub-national government', 
    'Joint governance (i.e. decisions are made by many)', 
    'Individual landowners', 
    'Collaborative governance (i.e. decisions are made by one group on behalf of many)', 
    'Other'
  ]

  scope :form_options, -> { where("default_option IS true") }
  scope :filter_options, -> { where("default_option IS true AND name != 'Sub-national government'") }
  
  has_and_belongs_to_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name

end
