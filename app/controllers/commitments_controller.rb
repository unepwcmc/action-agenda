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

  def list
    @commitments = PameEvaluation.paginate_commitments(params.to_json)

    render json: @commitments
  end
end
