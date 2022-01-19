
require 'wcmc_components'

class Country < ApplicationRecord
  include WcmcComponents::Loadable
  
  has_and_belongs_to_many :commitments
  validates :name, presence: true
  validates :name, uniqueness: true

  ignore_column 'iso_3'
  ignore_column 'language'
  ignore_column 'region'
  ignore_column 'bounding_box'
end
