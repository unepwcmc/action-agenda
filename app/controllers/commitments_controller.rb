class CommitmentsController < ApplicationController
  def index
  end

  def show
    @primary_objectives = [
      {
        title: 'Sustainable use'
      }
    ]
  end
end