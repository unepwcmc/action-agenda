class Admin::ImportedCommitmentsController < ActionController::Base
  layout 'application'

  before_action :authenticate_admin
  before_action :set_commitment, only: [:update]

  def index
    respond_to do |format|
      format.json { 
        @commitments = Commitment.cbd_without_government_managers.where(cfn_approved: cfn_approved_param) 
        render json: @commitments.as_json(only: [:id, :name, :description])
      }
      format.html {}
    end
  end

  def update
    respond_to do |format|
      format.json {
        if @commitment.update(commitment_params)
          render json: @commitment.as_json(only: [:id, :name, :description]), status: :ok
        else
          render json: @commitment.errors, status: :unprocessable_entity
        end
      }
    end
  end

  private

  def cfn_approved_param
    case params[:cfn_approved]
    when 'true'
      true
    when 'false'
      false
    else
      nil
    end
  end

  def authenticate_admin
    redirect_to root_path unless current_user&.admin?
  end

  def set_commitment
    @commitment = Commitment.find(params[:id])
  end

  def commitment_params
    params.require(:commitment).permit(:cfn_approved)
  end
end
