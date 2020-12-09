class CommitmentsController < ApplicationController
  DEFAULT_PARAMS =
  {
    requested_page: 1,
    filters: []
  }.to_json

  def index
    @paginatedCommitments = Commitment.paginate_commitments(DEFAULT_PARAMS).to_json
    # @commitments = Commitment.commitments_to_json
    @filters = Commitment.filters_to_json
    @table_attributes = Commitment::TABLE_ATTRIBUTES.to_json
  end

  def show
    @primary_objectives = [
      {
        icon: 'climate-change-mitigation',
        title: 'Climate Change Mitigation'
      }
    ]

    @targets_biodiversity = [5, 10] #Not sure how this will work yet
  end

  def list
    @commitments = PameEvaluation.paginate_commitments(params.to_json)

    render json: @commitments
  end
end