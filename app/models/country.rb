# frozen_string_literal: true

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

  scope :displayable, -> { where('lat IS NOT NULL AND long IS NOT NULL') }

  def country_commitments_json
    commitment_count_for_country = commitment_count
    managers = commitments
               .published
               .joins(:managers)
               .group('managers.name')
               .group('managers.id')
               .select("ROUND((COUNT(*)*100.0/#{commitment_count_for_country}), 0) AS percentage")
               .select('managers.name AS name')
               .select('COUNT(*) AS count')
               .select('managers.id AS id')
               .as_json(only: %i[id name percentage count])

    {
      country_name: name,
      commitment_count: commitment_count_for_country,
      managers: managers
    }
  end

  def commitment_count
    commitments.published.count
  end

  def commitments_path
    Rails.application.routes.url_helpers.commitments_path(
      {
        country_filters: {
          name: 'country',
          options: [name],
          type: 'multiple'
        }
      }
    )
  end

  def coordinates
    boundary&.coordinates&.first
  end
end
