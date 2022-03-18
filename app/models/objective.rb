class Objective < ApplicationRecord
  DEFAULT_OPTIONS = [
    'Sustainable use', 'Biodiversity conservation', 'Equitable sharing of benefits from the use of genetic resources', 'Restoration', 
    'Climate change adaptation and mitigation', 'Preservation of cultural values', 'Preservation of spiritual values', 
    'Preservation of traditional livelihoods', 'Certification of products', 'Recreation', 'Academic research'
  ]

  scope :commitment_form_options, -> { where(default_option: true) }

  has_and_belongs_to_many :commitments
  has_many :post2020_targets_commitment_activities, as: :commitment_activity
  has_many :post2020_targets, through: :post2020_targets_commitment_activities

  validates_presence_of :name
  validates_uniqueness_of :name
end
