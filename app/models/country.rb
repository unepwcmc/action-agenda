
require 'wcmc_components'

class Country < ApplicationRecord
  include WcmcComponents::Loadable
  
  has_and_belongs_to_many :commitments
  validates_presence_of :name
  validates_uniqueness_of :name

  ignore_column 'iso_3'
  ignore_column 'language'
  ignore_column 'region'
  ignore_column 'bounding_box'

  def commitment_count
    commitments.where(state: 'live').count
  end
end
