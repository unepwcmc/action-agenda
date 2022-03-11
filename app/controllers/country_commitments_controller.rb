class CountryCommitmentsController < ApplicationController
  before_action :set_country, only: [:show]

  def index
    respond_to do |format|
      format.json { 
        countries_with_commitments_ids = Commitment.where(state: 'live').joins(:countries).pluck('countries.id').uniq
        countries = Country.where(id: countries_with_commitments_ids).eager_load(:commitments)
        render json: countries.as_json(except: [:boundary, :created_at, :updated_at], methods: :commitment_count) 
      }
    end
  end

  def show
    respond_to do |format|
      format.json { 
        # return json object with:
          # boundary coordinates to allow zoom on country
          # commitment count
          # % of projects with each of the manager types
      }
    end
  end

  private

  def set_country
    @country = Country.find(params[:id])
  end
end