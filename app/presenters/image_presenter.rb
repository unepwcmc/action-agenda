class ImagePresenter
  include Rails.application.routes.url_helpers

  def initialize; end

  def main_logo
    [
      {
        alt: 'Nature Commitments logo',
        src: 'logos/NC_Logo-White.svg'
      }
    ]
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
      },
      {
        alt: 'Cities with Nature',
        src: 'logos/cities_with_nature.png'
      },
      {
        alt: 'UN Decade on Ecosystem Restoration',
        src: 'logos/UNDecade_on_ecosystem_restoration.png'
      }
    ]
  end
end
