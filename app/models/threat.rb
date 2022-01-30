class Threat < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Residential & commercial development', 'Agriculture & aquaculture', 'Energy production & mining', 'Transportation & service corridors',
    'Biological resource use', 'Human intrusions & disturbance', 'Natural system modifications', 'Invasive & other problematic species',
    'Genes & diseases', 'Pollution', 'Geological events', 'Climate change & severe weather', 'Other'
  ]

  scope :commitment_form_options, -> { where(default_option: true) }
  
  has_and_belongs_to_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name
end