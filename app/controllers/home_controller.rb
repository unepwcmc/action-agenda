class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    imagePresenter = ImagePresenter.new
    
    @partner_logos = imagePresenter.partner_logos
  end
end
