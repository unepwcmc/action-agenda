class ImagePresenter
  include Rails.application.routes.url_helpers

  def initialize
  end

  def site_logos
    [
      {
        alt: 'UNEP-WCMC logo',
        src: 'https://s3.amazonaws.com/wcmc.logo/UNEP_WCMC_logo_white.svg'
      },
      {
        alt: 'CBD logo',
        src: 'logos/cbd.png'
      }
    ]
  end

  def partner_logos
    [
      {
        alt: 'Government of the Netherlands',
        src: 'logos/government_of_the_netherlands.png'
      }
    ]
  end
end