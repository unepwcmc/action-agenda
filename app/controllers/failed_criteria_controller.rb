class FailedCriteriaController < ApplicationController
  before_action :set_criterium

  def show
  end

  private

  def set_criterium
    @criterium = Criteria.find(params[:id])
  end
end