class UsersController < ApplicationController
  def dashboard
    @commitments = Commitment.limit(5)
  end
end