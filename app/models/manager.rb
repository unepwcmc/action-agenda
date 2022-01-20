class Manager < ApplicationRecord
  has_and_belongs_to_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  DEFAULT_OPTIONS = [
    'Indigenous peoples', 'Local communities', 'For-profit organisations', 'Non-profit organisations', 'Individual landowners',
    'Collaborative governance', 'Joint governance', 'Sub-national ministry or agency', 'Other'
  ]
end
