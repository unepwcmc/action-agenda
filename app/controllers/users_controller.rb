class UsersController < ApplicationController
  def dashboard
    commitments = Commitment.limit(5)
    @commitments = commitments.to_json
    # for some reason .empty? returns true here if using @commitments with an empty array
    @has_commitments = !commitments.empty?
  end
end