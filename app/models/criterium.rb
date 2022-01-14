class Criterium < ApplicationRecord
  has_and_belongs_to_many :cbd_objectives
  has_and_belongs_to_many :stakeholders

  validates_inclusion_of :boundary, :five_year_commitment, :progress_report, in: [true, false], message: :nil_value

  def criteria_valid_for_commitment?
    ![boundary, five_year_commitment, progress_report, cbd_objective_ids, stakeholder_ids].map(&:blank?).include?(true)
  end

  def failure_messages
    messages = []
    
  end
end