class ProgressDocumentsController < ApplicationController
  before_action :set_progress_document, only: [:destroy, :update]

  def destroy
    if @progress_document.destroy
      respond_to do |format|
        format.json { json_response({}, 204) }
      end
    else
      respond_to do |format|
        format.json { json_response({ errors: @progress_document.errors }, :unprocessable_entity) }
      end
    end
  end

  def update
    if @progress_document.update(progress_document_params)
      respond_to do |format|
        format.json { json_response({}, 204) }
      end
    else
      respond_to do |format|
        format.json { json_response({ errors: @progress_document.errors }, :unprocessable_entity) }
      end
    end
  end

  private

  def set_progress_document
    @progress_document = progress_document.find(params[:id])
  end

  def progress_document_params
    params.require(:progress_document).permit(:name, :url)
  end
end
