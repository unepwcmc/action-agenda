class Criterium < ApplicationRecord
  has_and_belongs_to_many :cbd_objectives
  has_and_belongs_to_many :stakeholders

  validates_inclusion_of :boundary, :five_year_commitment, :progress_report, in: [true, false], message: :nil_value

  def criteria_valid_for_commitment?
    ![boundary, five_year_commitment, progress_report, cbd_objectives, stakeholders].map(&:blank?).include?(true)
  end

  def failure_messages
    messages = []
    %w(boundary five_year_commitment progress_report cbd_objectives stakeholders).each do |attribute|
      messages << I18n.t(:"criterium.failure_messages.#{attribute.to_s}") if self.send(attribute).blank?
    end
    messages
  end
end