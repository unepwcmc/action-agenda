require 'csv'
require 'wcmc_components'
class Commitment < ApplicationRecord
  STAGE_OPTIONS = ['In progress', 'Committed', 'Implemented fully']
  enum state: [:draft, :live] 

  include WcmcComponents::Loadable

  ignore_column 'review_method'
  ignore_column 'proposed_area_ha'

  has_and_belongs_to_many :countries
  import_by countries: :name
  has_and_belongs_to_many :objectives
  import_by objectives: :name
  has_and_belongs_to_many :governance_types
  import_by governance_types: :name
  has_and_belongs_to_many :actions
  import_by actions: :name
  has_and_belongs_to_many :threats
  import_by threats: :name
  has_many :links, dependent: :destroy
  import_by links: :url
  has_many :progress_documents, dependent: :destroy
  has_one_attached :geospatial_file

  belongs_to :manager, class_name: 'Manager', optional: true
  import_by manager: :name

  belongs_to :criterium, optional: true
  belongs_to :user, optional: true

  accepts_nested_attributes_for :links, reject_if: ->(attributes){ attributes['url'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :progress_documents, reject_if: ->(attributes){ attributes['document'].blank? }, allow_destroy: true

  validates :geospatial_file,
    content_type: %w(application/vnd.google-earth.kml+xml application/vnd.google-earth.kmz application/zip), 
    size: { less_than: 25.megabytes }

  validates :name, presence: true
  validates :stage, inclusion: { in: STAGE_OPTIONS }, if: :user_created_and_live?

  validates_presence_of :description, :latitude, :longitude, :committed_year, :responsible_group, :implementation_year,
                        :duration_years, :objectives, :manager, :countries, :actions, :threats, if: :user_created_and_live?
  
  TABLE_ATTRIBUTES = [
    {
      title: 'Name',
      field: 'name'
    },
    {
      title: 'Committed',
      field: 'committed'
    },
    {
      title: 'Duration',
      field: 'duration_years'
    },
    {
      title: 'Stage',
      field: 'stage'
    },
    {
      title: '',
      field: 'id'
    }
  ].freeze

  def draft_errors
    self.state = :live
    valid?
    self.state = :draft
    errors.messages.map do |key, value|
      if key.in?(%i(actions countries manager objectives threats))
        :"#{key.to_s.singularize}_ids"
      else
        key
      end
    end
  end

  FILTERS = %w[actor country committed_year stage primary_objectives].freeze

  # Filters moved to CommitmentPresenter to avoid repetition
  def self.filters_to_json
    # commitments = Commitment.all.order(id: :asc)
    sanitise_filters
    CommitmentPresenter.new.populate_filters
  end

  def self.commitments_to_json
    commitments = Commitment.all
                            .includes(:countries)
                            .order(id: :asc).to_a.map! do |commitment|
      {
        id: commitment.id,
        title: commitment.name,
        description: commitment.description,
        committed: commitment.committed_year
      }
    end.to_json
  end

  def self.paginate_commitments(json = nil)
    json_params = json.nil? ? nil : JSON.parse(json)
    page = json_params.present? ? json_params['requested_page'].to_i : 1
    @items_per_page = json_params.present? ? json_params['items_per_page'].to_i : 10
    @filter_params = nil
    if json_params.present?
      @filter_params = json_params['filters'].all? { |p| p['options'].blank? } ? [] : json_params['filters']
    end

    unpaginated_commitments = generate_query(page, @filter_params)
    paginated_commitments = unpaginated_commitments
                              .paginate(page: page || 1, per_page: @items_per_page)
                              .to_a.map! do |commitment|
                                commitment.to_hash
                              end

    structure_data(page, paginated_commitments, unpaginated_commitments.count)
  end
  
  def to_hash
    {
      id: id,
      title: name,
      description: description,
      committed: committed_year,
      duration_years: duration_years,
      stage: stage,
      url: Rails.application.routes.url_helpers.commitment_path(id),
      links: links
    }
  end

  def self.generate_query(page, filter_params)
    # if params are empty then return the paginated results without filtering
    if filter_params.empty?
      return Commitment.includes(:countries)
                       .where(state: 'live') # WARNING! Do not remove the 'live' query, because this will show unpublished Commitments people might not want public
                       .order(id: :asc)
    end

    # we have to do some hard work on the filtering...
    filters = filter_params.select { |hash| hash['options'].present? }
    where_params = parse_filters(filters)
    run_query(page, where_params)
  end

  def self.parse_filters(filters)
    country_ids = []
    objective_ids = []
    manager_ids = []
    params = {}
    FILTERS.each { |filter| params[filter] = nil }

    filters.each do |filter|
      options = filter['options']
      name = filter['name']
      case name
      when 'country'
        countries = options
        country_ids << Country.where(name: countries).pluck(:id)
        params['country'] = country_ids.flatten.empty? ? "" : "countries.id IN (#{country_ids.join(',')})"
      when 'actor'
        managers = options
        manager_ids << Manager.where(name: managers).pluck(:id)
        params['manager'] = manager_ids.flatten.empty? ? "" : "managers.id IN (#{manager_ids.join(',')})"
      when 'primary_objectives'
        objectives = options
        objective_ids << Objective.where(name: objectives).pluck(:id)
        params['objective'] = objective_ids.flatten.empty? ? "" : "objectives.id IN (#{objective_ids.join(',')})"
      else
        # Single quoted strings needed for the SQL queries to work properly
        params[name] = options.empty? ? "" : "commitments.#{name} IN (#{options.map { |op| "'#{op}'" }.join(',')})"
      end
    end

    params.compact
  end

  def self.run_query(page, where_params)
    Commitment.where(state: 'live') # WARNING! Do not remove the 'live' query, because this will show unpublished Commitments people might not want public
      .left_outer_joins(:manager, :countries, :objectives, :governance_types)
      .distinct
      .where(where_params.values.join(' AND '))
  end

  def self.sanitise_filters
    [Country].each do |model|
      var_name = "@#{model.to_s.underscore.pluralize}"
      instance_variable_set(var_name, model.pluck(:name).compact.sort - ['Data not available'])
    end
  end

  def self.structure_data(page, items, total_item_count)
    {
      current_page: page,
      per_page: @items_per_page,
      total_entries: total_item_count,
      total_pages: pages(total_item_count),
      items: items
    }
  end

  def self.pages(item_count)
    return 0 if item_count == 0
    (item_count / @items_per_page.to_d).ceil
  end

  private

  def user_created_and_live?
    live? && user_created?
  end
end
