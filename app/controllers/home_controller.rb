class HomeController < ApplicationController
  def index
    imagePresenter = ImagePresenter.new
    
    @partner_logos = imagePresenter.partner_logos
  end
end
