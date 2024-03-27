# frozen_string_literal: true

class Services::FermInitiativeHash
  def initialize(ferm_initiative_hash, commitment, manager_hash, action_hash, objective_hash, categorical_mappings_hash)
    @ferm_initiative_hash = ferm_initiative_hash
    @commitment = commitment
    @manager_hash = manager_hash
    @action_hash = action_hash # NC actions
    @objective_hash = objective_hash
    @action_mapping_array = categorical_mappings_hash['activities'] # FERM actions(activities)
  end

  def call
    {
      ferm_id: @ferm_initiative_hash['id'],
      name: @ferm_initiative_hash['title'],
      description: @ferm_initiative_hash['description'],
      country_ids: country_ids,
      committed_year: @ferm_initiative_hash['starting_date']&.split('-')&.first,
      update_year: @ferm_initiative_hash['last_updated']&.split('-')&.first,
      duration_years: duration_years,
      commitment_source: 'ferm',
      manager_ids: manager_ids, # type of managers, e.g. NGO, government, etc.
      cfn_approved: cfn_approved, # should also automatically decline it if has government managers
      state: 'live',
      stage: restoration_status,
      shareable: false,
      links_attributes: [
        link_attributes
      ],
      action_ids: action_ids,
      objective_ids: objective_ids,
      current_area_ha: ha_converted_area,
    }
  end

  def cfn_approved
    return false if government_managers?

    true
  end

  def government_managers?
    government_manager_ids = [
      @manager_hash['Other government'],
      @manager_hash['Sub-national government']
    ]

    (government_manager_ids & manager_ids).any?
  end

  def country_ids
    operational_areas = @ferm_initiative_hash['country_codes']

    return [global_country_id] if operational_areas.nil?

    countries = Country.where(iso: operational_areas)
    ids = countries.pluck(:id)
    ids.present? ? ids : [global_country_id]
  end

  def global_country_id
    Country.find_by(iso: '--').id
  end

  def duration_years
    return if @ferm_initiative_hash['starting_date'].blank? || @ferm_initiative_hash['ending_date'].blank?

    start_year = @ferm_initiative_hash['starting_date'].split('-').first.to_i
    end_year = @ferm_initiative_hash['ending_date'].split('-').first.to_i
    "#{end_year - start_year} years"
  end

  def link_attributes
    {
      id: @commitment.links.first&.id,
      url: "https://ferm-search.fao.org/initiatives/#{@ferm_initiative_hash['id']}"
    }
  end

  def manager_ids
    @manager_ids ||= begin
      actor_data = @ferm_initiative_hash['organizations']
      return [] unless actor_data

      # Generate a list of ids from our database starting from the ferm types
      actor_data.map { |actor| ferm_identifier_to_cfn_id(actor['type']) }.uniq
    end
  end

  def ferm_identifier_to_cfn_id(type)
    manager_name = manager_name_lookup(type)
    manager_id_lookup(manager_name)
  end

  def manager_id_lookup(name)
    @manager_hash[name]
  end

  def manager_name_lookup(type)
    # Mapping of Ferm organization types to our Manager types
    case type
    when 'NGO', 'Foundation'
      'Non-profit organisation'
    when 'Government'
      'Sub-national government'
    when 'Private sector'
      'For-profit organisation'
    when '', 'Other', 'Multilateral', 'Academic & research'
      'Other'
    when 'Public Private Partnership'
      'Collaborative governance'
    end
  end

  def action_ids
    return [] unless @ferm_initiative_hash['activities'].present?

    @ferm_initiative_hash['activities'].map do |activity|
      ferm_activity_mapping(activity)
    end.uniq
  end

  def ferm_activity_mapping(activity)
    parent_activity = nested_hash_value(@action_mapping_array, activity)
    activity_name = activity_name_lookup(parent_activity)
    activity_id_lookup(activity_name)
  end

  def nested_hash_value(action_array, value)
    action_array = action_array.first['items'] + action_array.second['items']
    action_name = action_array.detect do |parent|
      return parent['label'] if parent['label'] == value

      parent['items'].detect do |child|
        child['label'] == value
      end
    end
    action_name['label']
  end

  def activity_name_lookup(activity)
    case activity
    when 'Restoration of vegetation cover', 'Rehabilitation and depollution', 'Soil and water management', 'Agricultural/forestry/fishery/aquacultural management'
      'Management of land/water'
    when 'Control of invasive species'
      'Species management'
    when 'Legal and rights-based instruments'
      'Protection of land/water'
    when 'Social and cultural instruments', 'Capacity-building, skills and knowledge development'
      'Education or awareness-raising'
    when 'Integrated landscape planning'
      'Other'
    end
  end

  def activity_id_lookup(name)
    @action_hash[name]
  end

  def ha_converted_area
    case @ferm_initiative_hash['areas_unit']
    when 'ha'
      @ferm_initiative_hash['target_area']
    end
  end

  def restoration_status
    case @ferm_initiative_hash['restoration_status']
    when 'Planning'
      'Committed'
    when 'In progress'
      'In progress'
    when 'Post-completion monitoring'
      'Implemented fully'
    end
  end

  def objective_ids
    return [] unless @ferm_initiative_hash['objectives'].present?

    @ferm_initiative_hash['objectives'].map do |objective|
      objective_name = nc_ferm_objective_mapping(objective)
      @objective_hash[objective_name]
    end.uniq
  end

  def nc_ferm_objective_mapping(objective)
    case objective
    when 'Reforest degraded lands', 'Improve soil health', 'Ensure sustainability of restoration practices'
      'Restoration'
    when 'Increase food and products production', 'Improve water availability and quality', 'Improve access to energy', 'Improve livelihoods', 'Enhance ecosystem resilience', 'Other'
      'Other (e.g. ecosystem services)'
    when 'Improve biodiversity'
      'Biodiversity conservation'
    when 'Contribute to climate change adaptation and mitigation'
      'Climate change adaptation or mitigation'
    when 'Ensure/protect rights and culture'
      'Preservation of cultural values'
    end
  end
end
