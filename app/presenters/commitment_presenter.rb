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
    Commitment.pluck(:actor).uniq.compact.map(&:squish)
  end

  def country_filters
    Country.pluck(:name)
  end

  def committed_year_filters
    Commitment.where.not(committed_year: nil).distinct.pluck(:committed_year)
  end

  def duration_filters
    Commitment.pluck(:duration).uniq.compact.map(&:squish)
  end

  def status_filters
    Commitment.pluck(:status).uniq.compact.map(&:squish)
  end

  def primary_objectives_filters
    Commitment.pluck(:primary_objectives).uniq.compact.map(&:squish)
  end

  def governance_type_filters
    Commitment.pluck(:governance_type).uniq.compact.map(&:squish)
  end
end
