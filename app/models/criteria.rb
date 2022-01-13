class Criteria < ApplicationRecord
  has_and_belongs_to_many :stakeholders
  has_and_belongs_to_many :cbd_objectives

  validates_inclusion_of :boundary, :five_year_commitment, :progress_report, in: [true, false]

  def criteria_valid_for_commitment?
    ![boundary, five_year_commitment, progress_report, stakeholder_ids, cbd_objective_ids].map(&:blank?).any?
  end
end