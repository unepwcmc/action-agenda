class UsersController < ApplicationController
  def dashboard
    commitments = Commitment.limit(5) # placeholder until we have users in place
    @commitments = commitments.to_json
    @has_commitments = commitments.present?
  end
end