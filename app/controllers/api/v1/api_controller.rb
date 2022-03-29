module Api
  module V1
    class ApiController < ActionController::Base
      skip_before_action :verify_authenticity_token
    end
  end
end
