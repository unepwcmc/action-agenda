class Threat < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Residential or commercial development', 'Agriculture or aquaculture', 'Energy production or mining', 
    'Transportation or service corridors', 'Biological resource use', 'Human intrusions and disturbance', 
    'Natural system modifications', 'Invasive species, genetic threats, disease threats',
    'Pollution', 'Geological events', 'Climate change or severe weather', 'Other'
  ]

  scope :commitment_form_options, -> { where(default_option: true) }

  has_and_belongs_to_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name
end