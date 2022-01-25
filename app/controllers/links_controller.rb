class LinksController < ApplicationController
  before_action :set_link, only: [:update, :destroy]

  def update
    if @link.update(link_params)
      respond_to do |format|
        format.json { json_response({}, 204) }
      end
    else
      respond_to do |format|
        format.json { json_response({ errors: @link.errors }, :unprocessable_entity) }
      end
    end
  end

  def destroy
    if @link.destroy
      respond_to do |format|
        format.json { json_response({}, 204) }
      end
    else
      respond_to do |format|
        format.json { json_response({ errors: @link.errors }, :unprocessable_entity) }
      end
    end
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:name, :url)
  end
end

