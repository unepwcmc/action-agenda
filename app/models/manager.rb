class Manager < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Local communities', 'Indigenous peoples', 'Non-governmental organisation (NGO)', 
    'Private sector (business and industry)', 'Sub-national or local government', 'None of the above'
  ]

  scope :commitment_form_options, -> { where("default_option IS true AND name != 'None of the above'") }
  
  has_and_belongs_to_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name

end
