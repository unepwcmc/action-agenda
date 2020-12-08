class ImagePresenter
  include Rails.application.routes.url_helpers

  def initialize
  end

  def partner_logos
    [
      {
        alt: 'Earth mind logo',
        src: 'logos/earth-mind.png'
      },
      {
        alt: 'Ministry of Infrastructure and Water Management logo',
        src: 'logos/ministry-of-infrastructure-and-water-management.png'
      }
    ]
  end
end