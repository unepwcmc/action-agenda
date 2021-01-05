class CommitmentPresenter
  def populate_filters
    filters = Commitment::FILTERS.map do |filter|
      {
        name: filter,
        title: filter.capitalize,
        options: send("#{filter}_filters"),
        type: 'multiple'
      }
    end

    filters.find { |filter| filter[:name] == 'governance_type' }[:title] = 'Governance Type'
    filters.find { |filter| filter[:name] == 'committed_year' }[:title] = 'Committed'
    filters.find { |filter| filter[:name] == 'planned_actions' }[:title] = 'Objectives'

    filters.to_json
  end

  # TODO: - we need the type of org (actor) in the CSV
  def actor_filters
    []
  end

  def country_filters
    Country.pluck(:name)
  end

  def committed_year_filters
    Commitment.where.not(committed_year: nil).distinct.pluck(:committed_year)
  end

  def duration_filters
    Commitment.pluck(:duration).uniq
  end

  def status_filters
    Commitment.pluck(:status).uniq
  end

  # Possible TODO - how do we categorise the objectives?
  def planned_actions_filters
    Commitment.pluck(:planned_actions)
  end

  # TODO: - missing governance type
  def governance_type_filters
    []
  end
end
