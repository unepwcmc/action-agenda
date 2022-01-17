module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      respond_to do |format|
        format.json { json_response({ message: e.message }, :not_found) }
        format.html { render file: "#{Rails.root}/public/404", status: :not_found }
      end
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      respond_to do |format|
        format.json { json_response({ message: e.message }, :unprocessable_entity) }
        format.html { }
      end
    end
  end
end