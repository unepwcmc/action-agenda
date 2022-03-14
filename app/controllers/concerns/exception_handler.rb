module ExceptionHandler
  extend ActiveSupport::Concern

  class ForbiddenError < StandardError; end
  class MissingProgressDocumentAttachmentError < StandardError; end

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

    rescue_from ForbiddenError do |e|
      respond_to do |format|
        format.json { json_response({ message: I18n.t('errors.messages.forbidden_resource') }, :forbidden) }
        format.html { redirect_back fallback_location: root_path, notice: I18n.t('errors.messages.forbidden_resource') }
      end
    end

    rescue_from MissingProgressDocumentAttachmentError do |e|
      respond_to do |format|
        format.json { json_response({ errors: { message: [I18n.t('activerecord.errors.models.progress_document.attributes.document.document_missing')] }}, :unprocessable_entity) }
      end
    end
  end
end