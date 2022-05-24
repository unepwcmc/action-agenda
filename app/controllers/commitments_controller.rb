class CommitmentsController < ApplicationController
  DEFAULT_PARAMS =
    {
      items_per_page: 10,
      requested_page: 1,
      filters: []
    }

  skip_before_action :authenticate_user!, only: %i[index list show]
  before_action :set_commitment, only: %i[show edit update destroy]
  before_action :purge_geospatial_file, only: %i[update create]
  before_action :clean_progress_document_attachment_params, only: %i[update create]

  def index
    # make a copy of default params and modify those to prevent filters persisting over calls
    filter_params = DEFAULT_PARAMS.dup
    if params[:country_filters].present?
      filter_params[:filters] = []
      filter_params[:filters] << params[:country_filters]
    end

    @paginatedCommitments = Commitment.paginate_commitments(filter_params.to_json).to_json
    @commitments_count = Commitment.published.count
    @filters = Commitment.filters_to_json
    @table_attributes = Commitment::TABLE_ATTRIBUTES.to_json
    @preset_filters = filter_params[:filters]
  end

  def show
    # only allow the Commitment owner to see the Commitment unless it has been published
    redirect_to commitments_path unless @commitment.live? || @commitment.user == current_user

    @primary_objectives = @commitment.objectives.pluck(:name).map do |name|
      {
        icon: name.downcase.squish.gsub(' ', '-'),
        title: name
      }
    end

    @targets_biodiversity = []
    unless @commitment.related_biodiversity_targets.nil?
      @targets_biodiversity = @commitment.related_biodiversity_targets.scan(/\d+/).map(&:to_i)
    end

    @countries = @commitment.countries.map do |country|
      { name: country.name, commitments_path: country.commitments_path }
    end
  end

  def list
    # WARNING! Do not remove the 'published' scope, because this will show unpublished Commitments
    # people might not want public and CBD commitments we've chosen not to display.
    @commitments = Commitment.published.paginate_commitments(params.to_json)
    render json: @commitments
  end

  def new
    if params[:criterium_id] && criterium_id_valid?
      @commitment = Commitment.new(criterium_id: params[:criterium_id])
      @form_hash = Services::CommitmentProps.new(@commitment).call
    else
      redirect_to new_criterium_url
    end
  end

  def create
    @commitment = Commitment.new(commitment_params.merge(
                                   user: current_user,
                                   commitment_source: 'form',
                                   cfn_approved: true
                                 ))
    criterium = Criterium.find(@commitment.criterium_id)
    @commitment.manager_ids = [criterium.manager_id]

    if @commitment.save
      respond_to do |format|
        format.json { json_response({ commitment: @commitment, redirect_path: dashboard_path }, :created) }
      end
    elsif attempting_to_publish? && save_draft
      respond_to do |format|
        format.json do
          json_response({ commitment: @commitment, redirect_path: edit_commitment_path(@commitment) }, :created)
        end
      end
    else
      respond_to do |format|
        format.json do
          error_messages = @commitment.errors.messages.dup
          json_response({ errors: error_messages }, :unprocessable_entity)
        end
      end
    end
  end

  def edit
    raise ForbiddenError unless @commitment.user == current_user

    @form_hash = Services::CommitmentProps.new(@commitment).call
  end

  def update
    raise ForbiddenError unless @commitment.user == current_user

    if @commitment.update(commitment_params)
      respond_to do |format|
        format.json { json_response({ commitment: @commitment, redirect_path: dashboard_path }, :ok) }
      end
    elsif attempting_to_publish? && update_draft
      respond_to do |format|
        format.json do
          json_response({ commitment: @commitment, redirect_path: edit_commitment_path(@commitment) }, :ok)
        end
      end
    else
      respond_to do |format|
        format.json do
          error_messages = @commitment.errors.messages.dup
          json_response({ errors: error_messages }, :unprocessable_entity)
        end
      end
    end
  end

  def destroy
    raise ForbiddenError unless @commitment.user == current_user

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

  def save_draft
    @commitment.state = 'draft'
    @commitment.save
  end

  def update_draft
    set_commitment
    @commitment.update(commitment_params_as_draft)
  end

  def attempting_to_publish?
    !@published && [@commitment.state, commitment_params[:state]].include?('live')
  end

  def purge_geospatial_file
    if commitment_params[:geospatial_file].blank?
      params[:commitment] = params[:commitment].except(:geospatial_file)
      @commitment.geospatial_file.purge if @commitment && @commitment.geospatial_file.attached?
    end
  end

  def clean_progress_document_attachment_params
    return unless commitment_params[:progress_documents_attributes].present?

    new_progress_document_attributes = []
    invalid_progress_document_attributes = []

    commitment_params[:progress_documents_attributes].each do |progress_document_attributes|
      if progress_document_attributes[:document].present?
        new_progress_document_attributes << progress_document_attributes
      elsif progress_document_attributes[:progress_notes].present?
        invalid_progress_document_attributes << progress_document_attributes
      end
    end

    if invalid_progress_document_attributes.present?
      raise MissingProgressDocumentAttachmentError
    else
      commitment_params[:progress_documents_attributes] = new_progress_document_attributes
    end
  end

  def criterium_id_valid?
    criterium = Criterium.find(params[:criterium_id])
    criterium.commitment.nil? && criterium.user_id == current_user.id
  end

  def set_commitment
    @commitment = Commitment.find(params[:id])
    @published = @commitment.state == 'live'
  end

  def commitment_params
    params.require(:commitment).permit(
      :area_owner_and_role,
      :committed_year,
      :criterium_id,
      :current_area_ha,
      :description,
      :duration_years,
      :geospatial_file,
      :implementation_year,
      :latitude,
      :longitude,
      :name,
      :responsible_group,
      :shareable,
      :stage,
      :state,
      :manager_id,
      action_ids: [],
      country_ids: [],
      objective_ids: [],
      threat_ids: [],
      links_attributes: %i[id url _destroy],
      progress_documents_attributes: %i[id document progress_notes _destroy]
    )
  end

  def commitment_params_as_draft
    commitment_params.merge({ 'state': 'draft' })
  end
end
