class CommitmentsController < ApplicationController
  DEFAULT_PARAMS =
  {
    items_per_page: 10,
    requested_page: 1,
    filters: []
  }.to_json

  before_action :set_commitment, only: [:show, :edit, :update]

  def index
    @paginatedCommitments = Commitment.paginate_commitments(DEFAULT_PARAMS).to_json
    # @commitments = Commitment.commitments_to_json
    @filters = Commitment.filters_to_json
    @table_attributes = Commitment::TABLE_ATTRIBUTES.to_json
  end

  def show
    @primary_objectives = @commitment.objectives.pluck(:name).map do |name|
      {
        icon: name.downcase.squish.gsub(' ', '-'),
        title: name
      }
    end
    
    @targets_biodiversity = []
    @targets_biodiversity = @commitment.related_biodiversity_targets.scan(/\d+/).map(&:to_i) unless @commitment.related_biodiversity_targets.nil?
  end
  
  def list
    @commitments = Commitment.paginate_commitments(params.to_json)
    render json: @commitments
  end

  def new
    @commitment = Commitment.new(criterium_id: params[:criterium_id])
    # set @form_hash for use by vue component here
  end

  def create
    @commitment = Commitment.new(commitment_params)
    if @commitment.save
      respond_to do |format|
        format.json { json_response({ commitment: @commitment }, :created) }
      end
    else
      respond_to do |format|
        format.json { 
          error_messages = @commitment.errors.messages
          @commitment.state = :draft
          @commitment.save
          json_response({ errors: error_messages }, :unprocessable_entity) 
        }
      end
    end
  end

  def edit
    # set @form_hash for use by vue component here
  end

  def update
    if @commitment.update(commitment_params)
      respond_to do |format|
        format.json { json_response({ commitment: @commitment }, 204) }
      end
    else
      respond_to do |format|
        format.json { json_response({ errors: @commitment.errors }, :unprocessable_entity) }
      end
    end
  end

  private

  def set_commitment
    @commitment = Commitment.find(params[:id])
  end

  def commitment_params
    params.require(:commitment).permit(
      :geographic_boundary,
      :latitude,
      :longitude,
      :current_area_ha,
      :proposed_area_ha,
      :committed_year,
      :implementation_year,
      :update_year,
      :name,
      :governance_authority,
      :description,
      :duration,
      :stage,
      :related_biodiversity_targets,
      :review_method,
      :responsible_group,
      :state,
      :associations,
      :spatial_data,
      country_ids: [],
      action_ids: [],
      threat_ids: [],
      manager_ids: [],
      links_attributes: [],
      progress_documents_attributes: [:id, :progress_notes, :document]
    )
  end
end
