# coding: utf-8
require 'csv'
require 'wcmc_components'
class Commitment < ApplicationRecord

  include WcmcComponents::Loadable
  belongs_to :country, class_name: 'Country'
  import_by country: :name
  
  validates :name, presence: true

  ignore_column 'TYPE'

  TABLE_ATTRIBUTES = [
    {
      title: 'Name',
      field: 'name'
    },
    {
      title: 'Commited',
      field: 'committed'
    },
    {
      title: 'Duration',
      field: 'duration'
    },
    {
      title: 'Status',
      field: 'status'
    },
    {
      title: '',
      field: 'id'
    },
  ].freeze
  
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

  def self.paginate_commitments(json=nil, order=nil)
    json_params = json.nil? ? nil : JSON.parse(json)
    page = json_params.present? ? json_params["requested_page"].to_i : 1

    order = (order && ['ASC', 'DESC'].include?(order.upcase)) ? order : 'DESC'
    commitments = generate_query(page, json_params["filters"])
    items = commitments
    # items = serialise(commitments)
    structure_data(page, items)
  end

  private
  def self.generate_query(page, filter_params)
    # if params are empty then return the paginated results without filtering
    return Commitment.includes(:country)
      .order(id: :asc)
      .to_a.map! do |commitment|
      {
        id: commitment.id,
        title: commitment.name,
        description: commitment.description,
        committed: commitment.committed_year
      }
    end if filter_params.empty?

    # return PameEvaluation.where('protected_area_id IS NOT NULL AND restricted = false').order('id ASC').paginate(page: page || 1, per_page: 50) if filter_params.empty?

    # filters = filter_params.select { |hash| hash["options"].present? }

    # where_params = parse_filters(filters)
    # run_query(page, where_params)
  end

  def self.sanitise_filters
    [Country].each do |model|
      var_name = "@#{model.to_s.underscore.pluralize}"
      instance_variable_set(var_name, model.pluck(:name).compact.sort - ["Data not available"])
    end
    @committed_years = Commitment.distinct.pluck(:committed_year)
  end

  def self.structure_data(page, items)
    {
      current_page: page,
      per_page: 50, #TODO This number should be coming through from the frontend items_per_page
      total_entries: 10, # TODO make this work(items.count > 0 ? items[0][:total_entries] : 0),
      total_pages: 1, # TODO make this work (items.count > 0 ? items[0][:total_pages] : 0),
      items: items
    }
  end
end
