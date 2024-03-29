class Criterium < ApplicationRecord
  has_and_belongs_to_many :cbd_objectives
  
  has_one :commitment
  belongs_to :user
  belongs_to :manager

  validates_inclusion_of :boundary, :five_year_commitment, :progress_report, in: [true, false], message: :nil_value

  validates :cbd_objectives, presence: true
  validate :none_of_the_above_for_cbd_commitments
  validate :has_government_manager?

  def criteria_valid_for_commitment?
    !criteria_invalid_for_commitment?
  end

  def failure_messages
    messages = []
    messages << I18n.t(:"models.criterium.failure_messages.boundary") unless boundary
    messages << I18n.t(:"models.criterium.failure_messages.five_year_commitment") unless five_year_commitment
    messages << I18n.t(:"models.criterium.failure_messages.progress_report") unless progress_report
    messages << I18n.t(:"models.criterium.failure_messages.other_as_manager") if has_other_as_manager?
    messages << I18n.t(:"models.criterium.failure_messages.government_manager") if has_government_manager?
    messages << I18n.t(:"models.criterium.failure_messages.no_cbd_objectives") if has_none_of_the_above_cbd_objectives?
    messages
  end

  private

  def criteria_invalid_for_commitment?
    [boundary, five_year_commitment, progress_report, cbd_objective_ids, manager_id].map(&:blank?).include?(true) ||
      has_government_manager? ||
        has_other_as_manager? ||
          has_none_of_the_above_cbd_objectives?
  end

  def cbd_objective_names
    cbd_objectives.pluck(:name)
  end

  def has_government_manager?
    manager&.name == ('Sub-national government')
  end

  def has_other_as_manager?
    manager&.name == ('Other')
  end

  def has_none_of_the_above_cbd_objectives?
    cbd_objective_names.include?('None of the above')
  end

  def none_of_the_above_for_cbd_commitments
    if has_none_of_the_above_cbd_objectives? && cbd_objective_ids.length > 1
      errors.add(:base, :none_of_the_above_option_for_cbd_commitments)
    end
  end
end