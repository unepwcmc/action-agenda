class CommitmentPresenter
  def populate_filters
    filters = Commitment::FILTERS.map do |filter|
      {
        name: filter,
        title: filter.gsub(/_/, ' '),
        options: get_filters(filter),
        type: 'multiple'
      }
    end

    filters.find { |filter| filter[:name] == 'committed_year' }[:title] = 'Committed'
    filters.find { |filter| filter[:name] == 'primary_objectives' }[:title] = 'Objectives'

    filters.to_json
  end

  def get_filters(filter)
    case filter
    when 'country'
      Country.pluck(:name).sort
    when 'committed_year'
      Commitment.where.not(committed_year: nil).distinct.pluck(:committed_year)
    when 'manager'
      Manager.pluck(:name).sort
    when 'primary_objectives'
      Objective.pluck(:name).sort
    when 'governance_type'
      GovernanceType.pluck(:name).sort
    else
      Commitment.pluck(filter.to_sym).uniq.compact.map(&:squish)
    end
  end
end
