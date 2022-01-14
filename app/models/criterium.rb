class Criterium < ApplicationRecord
  has_and_belongs_to_many :cbd_objectives
  has_and_belongs_to_many :stakeholders

  validates_inclusion_of :boundary, :five_year_commitment, :progress_report, in: [true, false], message: :nil_value

  validates :cbd_objectives, presence: true
  validates :stakeholders, presence: true
  validate :none_of_the_above_for_cbd_commitments
  validate :none_of_the_above_for_stakeholders

  def criteria_valid_for_commitment?
    !criteria_invalid_for_commitment?
  end

  def failure_messages
    messages = []
    messages << I18n.t(:"criterium.failure_messages.boundary") unless boundary
    messages << I18n.t(:"criterium.failure_messages.five_year_commitment") unless five_year_commitment
    messages << I18n.t(:"criterium.failure_messages.progress_report") unless progress_report
    messages << I18n.t(:"criterium.failure_messages.government_stakeholders") if stakeholders.pluck(:name).include?('Sub-national or local government')
    messages << I18n.t(:"criterium.failure_messages.no_cbd_objectives") if cbd_objectives.pluck(:name).include?('None of the above')
    messages
  end

  private

  def criteria_invalid_for_commitment?
    [boundary, five_year_commitment, progress_report, cbd_objective_ids, stakeholder_ids].map(&:blank?).include?(true) ||
      stakeholders.pluck(:name).include?('Sub-national or local government') ||
        cbd_objectives.pluck(:name).include?('None of the above')
  end

  def none_of_the_above_for_cbd_commitments
    if includes_none_of_the_above_and_another_record(CbdObjective, cbd_objective_ids)
      errors.add(:base, :none_of_the_above_option_for_cbd_commitments)
    end
  end

  def none_of_the_above_for_stakeholders
    if includes_none_of_the_above_and_another_record(Stakeholder, stakeholder_ids)
      errors.add(:base, :none_of_the_above_option_for_stakeholders)
    end
  end

  def includes_none_of_the_above_and_another_record(klass, record_ids)
    klass.where(id: record_ids).pluck(:name).include?('None of the above') && record_ids.length > 1
  end
end