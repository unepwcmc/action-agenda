class CriteriaController < ApplicationController
  before_action :set_criterium, only: [:ineligible]

  def new
    @criterium = Criterium.new
  end

  def create
    @criterium = Criterium.new(criterium_params)

    respond_to do |format|
      if @criterium.save
        format.json {
          redirect_path = @criterium.criteria_valid_for_commitment? ? new_commitment_path(criterium_id: @criterium.id) : ineligible_criteria_url(@criterium)
          json_response({ criterium: @criterium, redirect_path: redirect_path }, :created)
        }
      else
        format.json { json_response({ errors: @criterium.errors }, :unprocessable_entity) }
      end
    end
  end

  def ineligible
  end

  private

  def set_criterium
    @criterium = Criterium.find(params[:id])
  end

  def criterium_params
    params.require(:criterium).permit(
      :boundary,
      :five_year_commitment,
      :progress_report,
      stakeholder_ids: [],
      cbd_objective_ids: []
    )
  end
end