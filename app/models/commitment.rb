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

  def to_hash
    {
        id: id,
        title: name,
        description: description,
        committed: committed_year,
        duration: duration,
        status: status,
        url: Rails.application.routes.url_helpers.commitment_path(id),
        link: link
    }
  end
  
  private
  def self.generate_query(page, filter_params)
    # if params are empty then return the paginated results without filtering

    return Commitment.includes(:country)
      .order(id: :asc)
      .to_a.map! do |commitment|
      commitment.to_hash
    end if filter_params.empty?

    # we have to do some hard work on the filtering...
    filters = filter_params.select { |hash| hash["options"].present? }
    where_params = parse_filters(filters)
    run_query(page, where_params).to_a.map! do |commitment|
      commitment.to_hash
    end 
  end

  def self.parse_filters(filters)
    committed_years = []
    country_ids = []
    where_params = {committed_year: "", country: ""}
    filters.each do |filter|
      options = filter["options"]
      case filter['name']
      when 'committed'
        where_params[:committed_year] = options.empty? ? nil : "commitments.committed_year IN (#{options.join(',')})"
      when 'country'
#        countries = options
#        site_ids << countries.map{ |iso3| Country.find_by(iso_3: iso3).protected_areas.pluck(:id) }
#        where_params[:sites] = site_ids.flatten.empty? ? nil : "pame_evaluations.protected_area_id IN (#{site_ids.join(',')})"
#        country_ids << countries.map{ |iso3| "#{ Country.find_by(iso_3: iso3).id }" }
#        where_params[:iso3] = country_ids.flatten.empty? ? nil : "countries.id IN (#{country_ids.join(',')})"
      end
    end
    where_params
  end

  def self.run_query(page, where_params)
      Commitment
      .where(where_params[:committed_year])
      .paginate(page: page || 1, per_page: 50).order('id ASC')
  end

  
  
  def self.sanitise_filters
    [Country].each do |model|
      var_name = "@#{model.to_s.underscore.pluralize}"
      instance_variable_set(var_name, model.pluck(:name).compact.sort - ["Data not available"])
    end
    @committed_years = Commitment.where.not(committed_year: nil).distinct.pluck(:committed_year)
  end

  def self.structure_data(page, items)
    {
      current_page: page,
      per_page: 50, #TODO This number should be coming through from the frontend items_per_page
      total_entries: items.count,
      total_pages: 1, # TODO make this work (items.count > 0 ? items[0][:total_pages] : 0),
      items: items
    }
  end
end
