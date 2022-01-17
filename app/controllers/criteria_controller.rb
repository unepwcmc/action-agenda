class CriteriaController < ApplicationController
  def new
    @criterium = Criterium.new
  end

  def create
    @criterium = Criterium.new(criterium_params)

    respond_to do |format|
      if @criterium.save
        format.json {
          redirect_path = @criterium.criteria_valid_for_commitment? ? new_criterium_commitment_path(@criterium) : failed_criterium_path(@criterium)
          json_response({ criterium: @criterium, redirect_path: redirect_path }, :created)
        }
      else
        format.json { render json: { errors: @criterium.errors }, status: :unprocessable_entity }
      end
    end
  end

  private

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