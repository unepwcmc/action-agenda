require 'csv'
require 'wcmc_components'
class Commitment < ApplicationRecord
  STAGE_OPTIONS = ['In progress', 'Committed only', 'Implemented fully']
  enum state: [:draft, :live] 

  include WcmcComponents::Loadable
  ignore_column 'criterium'

  has_and_belongs_to_many :countries
  import_by countries: :name
  has_and_belongs_to_many :managers
  import_by managers: :name
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
                        :duration_years, :objectives, :managers, :countries, :actions, :threats, if: :user_created_and_live?
  
  validate :has_joint_governance_description, if: :user_created_and_live?

  before_save :clear_joint_governance_description_if_not_joint_governance_managed

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
      if key.in?(%i(actions countries managers objectives threats))
        :"#{key.to_s.singularize}_ids"
      else
        key
      end
    end
  end

  FILTERS = %w[actor country committed_year stage primary_objectives governance_type].freeze

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

    commitments = generate_query(page, @filter_params)
    items = commitments

    structure_data(page, items)
  end
  
  def to_hash
    {
      id: id,
      title: name,
      description: description,
      committed: committed_year,
      duration: duration_years || duration,
      stage: stage,
      url: Rails.application.routes.url_helpers.commitment_path(id),
      links: links
    }
  end

  def self.generate_query(page, filter_params)
    # if params are empty then return the paginated results without filtering
    if filter_params.empty?
      return Commitment.includes(:countries)
                       .where(state: 'live')
                       .order(id: :asc).paginate(page: page || 1, per_page: @items_per_page)
                       .to_a.map! do |commitment|
               commitment.to_hash
             end
    end

    # we have to do some hard work on the filtering...
    filters = filter_params.select { |hash| hash['options'].present? }
    where_params = parse_filters(filters)
    run_query(page, where_params).to_a.map! do |commitment|
      commitment.to_hash
    end
  end

  def self.parse_filters(filters)
    country_ids = []
    objective_ids = []
    governance_type_ids = []
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
      when 'governance_type'
        governance_types = options
        governance_type_ids << GovernanceType.where(name: governance_types).pluck(:id)
        params['governance_type'] = governance_type_ids.flatten.empty? ? "" : "governance_types.id IN (#{governance_type_ids.join(',')})"
      else
        # Single quoted strings needed for the SQL queries to work properly
        params[name] = options.empty? ? "" : "commitments.#{name} IN (#{options.map { |op| "'#{op}'" }.join(',')})"
      end
    end

    params.compact
  end

  def self.run_query(page, where_params)
    Commitment.left_outer_joins(:managers, :countries, :objectives, :governance_types)
      .distinct
      .where(where_params.values.join(' AND '))
      .paginate(page: page || 1, per_page: @items_per_page).order(id: :asc)
  end

  def self.sanitise_filters
    [Country].each do |model|
      var_name = "@#{model.to_s.underscore.pluralize}"
      instance_variable_set(var_name, model.pluck(:name).compact.sort - ['Data not available'])
    end
  end

  def self.structure_data(page, items)
    {
      current_page: page,
      per_page: @items_per_page,
      total_entries: entries(items),
      total_pages: pages(items),
      items: items
    }
  end

  def self.entries(items)
    @filter_params.empty? ? Commitment.count : items.count
  end

  def self.pages(items) 
    return 0 if items.count == 0

    total_pages = items.each_slice(@items_per_page).count

    if @filter_params.empty?
      total_pages = Commitment.all.each_slice(@items_per_page).count
    end

    total_pages
  end

  private

  def clear_joint_governance_description_if_not_joint_governance_managed
    self.joint_governance_description = '' unless joint_governance?
  end

  def has_joint_governance_description
    errors.add(:joint_governance_description, :description_blank) if joint_governance_description.blank? && joint_governance?
  end

  def joint_governance?
    Manager.where(id: manager_ids).pluck(:name).include?('Joint governance')
  end

  def user_created_and_live?
    live? && user_created?
  end
end
