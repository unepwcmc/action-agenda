# coding: utf-8
require 'csv'
require 'wcmc_components'
class Commitment < ApplicationRecord

  include WcmcComponents::Loadable
  belongs_to :country, class_name: 'Country'
  import_by country: :name
  
  validates :name, presence: true

  ignore_column 'TYPE'
  
  def self.filters_to_json
    commitments = Commitment.all.order(id: :asc)
    sanitise_filters
    filters = [
      {
        title:"ID"
      },
      {
        title: "Commitment"
      },
      {
        name: "committed",
        title: "Committed",
        options: @committed_years,
        type: 'multiple'
      },
      {
        name: "country",
        title: "Country",
        options: @countries,
        type: 'multiple'
      },


    ].to_json

  end

    def self.commitments_to_json
    commitments = Commitment.all
                 .includes(:country)
                 .order(id: :asc).to_a.map! do |commitment|
      {
        id: commitment.id,
        title: commitment.name,
        description: commitment.description,
        committed: commitment.committed_year
      }
    end.to_json
  end

    private
    def self.sanitise_filters
      [Country].each do |model|
        var_name = "@#{model.to_s.underscore.pluralize}"
        instance_variable_set(var_name, model.pluck(:name).compact.sort - ["Data not available"])
      end
      @committed_years = Commitment.distinct.pluck(:committed_year)
    end


    
end
