class FailedCriteriaController < ApplicationController
  before_action :set_criterium

  def show
  end

  private

  def set_criterium
    @criterium = Criterium.find(params[:id])
  end
end