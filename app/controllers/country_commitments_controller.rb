class CountryCommitmentsController < ApplicationController
  before_action :set_country, only: [:show]
  skip_before_action :authenticate_user!
  
  def index
    respond_to do |format|
      format.json { 
        countries_with_commitments_ids = Commitment.where(state: 'live').joins(:countries).pluck('countries.id').uniq
        countries = Country.where(id: countries_with_commitments_ids).displayable.eager_load(:commitments)
        render json: countries.as_json(except: [:boundary, :created_at, :updated_at], methods: :commitment_count) 
      }
    end
  end

  def show
    respond_to do |format|
      format.json {
        render json: @country.country_commitments_json.merge(
          country_commitments_path: commitments_path({ filters: { name: 'country', options: [@country.name], type: 'multiple' }})
        )
      }
    end
  end

  private

  def set_country
    @country = Country.find(params[:id])
  end
end