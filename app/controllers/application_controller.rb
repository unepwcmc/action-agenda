class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler

  before_action :authenticate_user!
end
