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
      before_years = Commitment.where('committed_year ILIKE ?', "%before%").distinct.pluck(:committed_year).sort
      other_years = Commitment.where('committed_year IS NOT NULL AND committed_year NOT ILIKE ?', "%before%").distinct.pluck(:committed_year).sort
      before_years + other_years
    when 'actor'
      Manager.filter_options.pluck(:name).sort
    when 'primary_objectives'
      Objective.commitment_form_options.pluck(:name).sort
    else
      Commitment.pluck(filter.to_sym).uniq.compact.map(&:squish).sort
    end
  end
end
