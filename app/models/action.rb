class Action < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Protection of land/water', 'Management of land/water', 'Species management', 'Education or awareness-raising',
    'Changes to law or policy', 'Economic or other incentives to influence behaviour', 'Other'
  ]

  scope :commitment_form_options, -> { where(default_option: true) }
  
  has_and_belongs_to_many :commitments
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
