# frozen_string_literal: true

module Api
  module V1
    class CommitmentsController < ApiController
      def index
        # @TODO: need a new scope that only includes published + shareable.
        commitments = Commitment
                      .published
                      .paginate(
                        page: params[:page] || 1,
                        per_page: params[:per_page] || 10
                      )

        commitments_json = commitments.as_json(
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

        render json: commitments_json
      end
    end
  end
end
