class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler
  
  skip_forgery_protection  
end
