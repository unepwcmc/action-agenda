class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    imagePresenter = ImagePresenter.new
    @partner_logos = imagePresenter.partner_logos

    live_commitments = Commitment.where(state: 'live')
    countries_with_commitments_ids = live_commitments.joins(:countries).pluck('countries.id').uniq
    commitment_countries = Country.displayable.where(id: countries_with_commitments_ids).eager_load(:commitments)
    @commitments_count = live_commitments.count
    @commitments_spatial_data = commitment_countries.as_json(except: %i[boundary created_at updated_at],
                                                             methods: [:commitment_count])
    @countries = Country.displayable.as_json(only: %i[id name], methods: [:coordinates])
  end
end
