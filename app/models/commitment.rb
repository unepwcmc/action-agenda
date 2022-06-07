# frozen_string_literal: true

require 'csv'
require 'wcmc_components'
class Commitment < ApplicationRecord
  STAGE_OPTIONS = ['In progress', 'Committed', 'Implemented fully'].freeze
  enum state: %i[draft live]
  enum commitment_source: %i[form csv cbd]

  include WcmcComponents::Loadable

  ignore_column 'review_method'
  ignore_column 'proposed_area_ha'

  has_and_belongs_to_many :actions
  import_by actions: :name
  has_and_belongs_to_many :countries
  import_by countries: :name
  has_and_belongs_to_many :governance_types
  import_by governance_types: :name
  has_many :links, dependent: :destroy
  import_by links: :url
  has_and_belongs_to_many :managers
  import_by managers: :name
  has_and_belongs_to_many :objectives
  import_by objectives: :name
  has_and_belongs_to_many :threats
  import_by threats: :name

  has_many :progress_documents, dependent: :destroy
  has_one_attached :geospatial_file

  belongs_to :criterium, optional: true
  belongs_to :user, optional: true

  accepts_nested_attributes_for :links, allow_destroy: true
  accepts_nested_attributes_for :progress_documents, allow_destroy: true

  validates :geospatial_file,
            content_type: %w[application/vnd.google-earth.kml+xml application/vnd.google-earth.kmz application/zip],
            size: { less_than: 25.megabytes }

  validates :name, presence: true
  validates :stage, inclusion: { in: STAGE_OPTIONS }, if: :user_created_and_live?

  validates_presence_of :description, :latitude, :longitude, :committed_year, :responsible_group, :implementation_year,
                        :duration_years, :objectives, :managers, :countries, :actions, :threats, if: :user_created_and_live?

  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 },
                       if: :user_created_and_live?
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 },
                        if: :user_created_and_live?

  validate :name_is_10_words_or_less, if: :user_created_and_live?

  scope :published, -> { where(state: 'live', cfn_approved: true) }
  scope :api_records, lambda {
    where(state: 'live', cfn_approved: true, shareable: true, commitment_source: %w[csv form])
  }
  scope :cbd_without_government_managers, lambda {
    government_manager_ids = Manager.where(name: ['Other government', 'Sub-national government'])
    where(commitment_source: 'cbd')
      .joins(:managers)
      .where('managers.id NOT IN (?)', Array.wrap(government_manager_ids))
  }

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
    errors_to_form_fields
  end

  def errors_to_form_fields
    errors.messages.map do |key, _value|
      if key.in?(%i[actions countries managers objectives threats])
        :"#{key.to_s.singularize}_ids"
      elsif key.to_s == 'progress_documents.document'
        :progress_documents_attributes
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

    unpaginated_commitments = generate_query(@filter_params)
    paginated_commitments = unpaginated_commitments
                            .paginate(page: page || 1, per_page: @items_per_page)
                            .to_a.map!(&:to_hash)

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

  def self.generate_query(filter_params)
    # if params are empty then return the paginated results without filtering
    # WARNING! Do not remove the 'published' scope, because this will show
    # unpublished Commitments people might not want public and CBD commitments
    # we've chosen not to display.
    if filter_params.empty?
      return Commitment.published
                       .includes(:countries)
                       .order(id: :asc)
    end

    # we have to do some hard work on the filtering...
    filters = filter_params.select { |hash| hash['options'].present? }
    where_params = parse_filters(filters)
    run_query(where_params)
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
        params['country'] = country_ids.flatten.empty? ? '' : "countries.id IN (#{country_ids.join(',')})"
      when 'actor'
        managers = options
        manager_ids << Manager.where(name: managers).pluck(:id)
        params['manager'] = manager_ids.flatten.empty? ? '' : "managers.id IN (#{manager_ids.join(',')})"
      when 'primary_objectives'
        objectives = options
        objective_ids << Objective.where(name: objectives).pluck(:id)
        params['objective'] = objective_ids.flatten.empty? ? '' : "objectives.id IN (#{objective_ids.join(',')})"
      else
        # Single quoted strings needed for the SQL queries to work properly
        params[name] = options.empty? ? '' : "commitments.#{name} IN (#{options.map { |op| "'#{op}'" }.join(',')})"
      end
    end

    params.compact
  end

  def self.run_query(_page, where_params)
    # WARNING! Do not remove the 'published' scope, because this will show unpublished Commitments
    # people might not want public and CBD commitments we've chosen not to display.
    Commitment.published
              .left_outer_joins(:managers, :countries, :objectives, :governance_types)
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
    live? && commitment_source == 'form'
  end

  def name_is_10_words_or_less
    errors.add(:name, :too_long) if name && name.split(' ').length > 10
  end
end
