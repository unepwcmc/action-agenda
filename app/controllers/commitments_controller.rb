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
  end
end