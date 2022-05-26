module Api
  module V1
    class ApiController < ActionController::Base
      include Response
      include ExceptionHandler
    end
  end
end
