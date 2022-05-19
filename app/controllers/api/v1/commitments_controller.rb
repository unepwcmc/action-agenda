# frozen_string_literal: true

module Api
  module V1
    class CommitmentsController < ApiController
      skip_before_action :verify_authenticity_token
      before_action :validate_params

      def index
        commitments = Commitment
                      .api_records
                      .paginate(
                        page: params[:page] || 1,
                        per_page: params[:per_page] || 10
                      )

        render json: commitments_to_json(commitments), status: :ok
      rescue StandardError => e
        render json: { message: e }, status: :unprocessable_entity
      end

      private

      def validate_params
        return unless params[:per_page].to_i > 50

        render json: {
          message: I18n.t('controllers.api.v1.commitments.per_page.exceeds_maximum')
        }, status: :unprocessable_entity
      end

      def commitments_to_json(commitments)
        commitments.eager_load(:manager,
                               :actions,
                               :countries,
                               :objectives,
                               :threats,
                               :links).as_json(
                                 only: %i[
                                   id
                                   area_owner_and_role
                                   committed_year
                                   current_area_ha
                                   description
                                   duration_years
                                   geospatial_file
                                   implementation_year
                                   latitude
                                   longitude
                                   name
                                   responsible_group
                                   stage
                                   created_at
                                   updated_at
                                 ],
                                 include: {
                                   manager: { only: %i[id name] },
                                   actions: { only: %i[id name] },
                                   countries: { only: %i[id name iso] },
                                   objectives: { only: %i[id name] },
                                   threats: { only: %i[id name] },
                                   links: { only: %i[id url] }
                                 }
                               )
      end
    end
  end
end
