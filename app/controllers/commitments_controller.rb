class CommitmentsController < ApplicationController
  DEFAULT_PARAMS =
  {
    items_per_page: 10,
    requested_page: 1,
    filters: []
  }.to_json

  before_action :set_commitment, only: [:show, :edit, :update, :destroy]

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
    @form_hash = Services::CommitmentProps.new(@commitment).call
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
          error_messages = @commitment.errors.messages.dup
          @commitment.state = :draft
          @commitment.save
          json_response({ errors: error_messages }, :unprocessable_entity) 
        }
      end
    end
  end

  def edit
    @form_hash = Services::CommitmentProps.new(@commitment).call
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

  def destroy
    if @commitment.destroy
      respond_to do |format|
        format.json { json_response({}, 204) }
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
      :commitment_id,
      :committed_year,
      :current_area_ha,
      :description,
      :duration_years,
      :geospatial_file,
      :implementation_year,
      :joint_governance_description,
      :latitude,
      :longitude,
      :name,
      :responsible_group,
      :stage,
      :state,
      action_ids: [],
      country_ids: [],
      manager_ids: [],
      objective_ids: [],
      threat_ids: [],
      links_attributes: [:id, :name, :url, :_destroy],
      progress_documents_attributes: [:id, :document, :progress_notes, :_destroy]
    )
  end
end
