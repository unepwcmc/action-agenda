class CommitmentsController < ApplicationController
  DEFAULT_PARAMS =
  {
    items_per_page: 10,
    requested_page: 1,
    filters: []
  }.to_json

  def index
    @paginatedCommitments = Commitment.paginate_commitments(DEFAULT_PARAMS).to_json
    # @commitments = Commitment.commitments_to_json
    @filters = Commitment.filters_to_json
    @table_attributes = Commitment::TABLE_ATTRIBUTES.to_json
  end
   
  def new
    @commitment = Commitment.new
    @form_hash = Services::CommitmentProps.new(@commitment).call
  end 
  
  # TODO
  def update
  end

  def show
    @commitment = Commitment.find(params[:id])

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
end
