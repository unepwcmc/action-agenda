class UsersController < ApplicationController
  def dashboard
    commitments = current_user.admin? ? Commitment.published : current_user.commitments
    @commitments = commitments.to_json
    @has_commitments = commitments.present?
  end
end
