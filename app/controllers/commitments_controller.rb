class CommitmentsController < ApplicationController
  def index
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
end