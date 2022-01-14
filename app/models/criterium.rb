class Criterium < ApplicationRecord
  has_and_belongs_to_many :cbd_objectives
  has_and_belongs_to_many :stakeholders

  validates_inclusion_of :boundary, :five_year_commitment, :progress_report, in: [true, false], message: :nil_value
  validates :cbd_objectives, presence: true
  validates :stakeholders, presence: true
  validate :none_of_the_above_for_cbd_commitments
  validate :none_of_the_above_for_stakeholders

  def criteria_valid_for_commitment?
    !has_failing_data
  end

  private

  def none_of_the_above_for_cbd_commitments
    if includes_none_of_the_above(CbdObjective, cbd_objective_ids) && cbd_objectives.length > 1
      errors.add(:base, :none_of_the_above_option_for_cbd_commitments)
    end
  end
  
  def none_of_the_above_for_stakeholders
    if includes_none_of_the_above(Stakeholder, stakeholder_ids) && stakeholders.length > 1
      errors.add(:base, :none_of_the_above_option_for_stakeholders)
    end
  end

  def includes_none_of_the_above(klass, record_ids) 
    klass.where(id: record_ids).pluck(:name).include?('None of the above')
  end

  def has_failing_data
    [boundary, five_year_commitment, progress_report].map(&:blank?).include?(true) ||
        includes_none_of_the_above(CbdObjective, cbd_objective_ids) ||
          includes_none_of_the_above(Stakeholder, stakeholder_ids)
  end
end