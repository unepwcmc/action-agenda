class CommitmentPresenter
  def populate_filters
    filters = Commitment::FILTERS.map do |filter|
      {
        name: filter,
        title: filter.gsub(/_/, ' '),
        options: send("#{filter}_filters"),
        type: 'multiple'
      }
    end

    filters.find { |filter| filter[:name] == 'committed_year' }[:title] = 'Committed'
    filters.find { |filter| filter[:name] == 'primary_objectives' }[:title] = 'Objectives'

    filters.to_json
  end

  def actor_filters
    Commitment.pluck(:actor)
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
  def primary_objectives_filters
    Commitment.pluck(:planned_actions)
  end

  def governance_type_filters
    Commitment.pluck(:governance_type)
  end

  def review_method_filters 
    Commitment.pluck(:review_method)
  end
end
