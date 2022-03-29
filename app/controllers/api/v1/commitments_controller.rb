module Api
  module V1
    class CommitmentsController < ApiController
      def index
        @commitments = Commitment.live
        render json: @commitments.as_json(
          only: [
            :id,
            :latitude,
            :longitude,
            :current_area_ha,
            :committed_year,
            :implementation_year,
            :duration_years,
            :name,
            :stage,
            :area_owner_and_role,
            :description
          ],
          include: {
            links: { only: [:id, :url] },
            managers: { only: [:id, :name] },
            countries: { only: [:iso, :name] },
            objectives: { only: [:id, :name] },
            actions: { only: [:id, :name] },
            threats: { only: [:id, :name] }
          }
        )
      end
    end
  end
end
