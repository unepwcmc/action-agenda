class CommitmentsController < ApplicationController
  def index
    @filters = Commitment.filters_to_json
    @commitments = Commitment.commitments_to_json
  end
end
