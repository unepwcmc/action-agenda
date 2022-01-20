class Threat < ApplicationRecord
  has_and_belongs_to_many :criteria
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  DEFAULT_OPTIONS = [
    'Residential & commercial development', 'Agriculture & aquaculture', 'Energy production & mining', 'Transportation & service corridors',
    'Biological resource use', 'Human intrusions & disturbance', 'Natural system modifications', 'Invasive & other problematic species',
    'genes & diseases', 'Pollution', 'Geological events', 'Climate change & severe weather', 'Other'
  ]
end