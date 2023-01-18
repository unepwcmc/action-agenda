class NavigationPresenter
  include Rails.application.routes.url_helpers

  def initialize; end

  def nav_header(signed_in)
    links_array = [
      {
        title: 'Home',
        url: home_path
      },
      {
        title: 'Make a Commitment',
        url: new_criterium_path
      },
      {
        title: 'Explore Commitments',
        url: commitments_path
      },
      {
        title: 'About',
        url: about_path
      }
    ]

    if signed_in
      dashboard_link = {
        title: 'My dashboard',
        url: dashboard_path
      }

      links_array.insert(1, dashboard_link)
    end

    links_array
  end

  def nav_footer
    [
      {
        title: 'Make a Commitment',
        url: new_criterium_path
      },
      {
        title: 'Explore Commitments',
        url: commitments_path
      },
       {
        title: 'CONTACT US: nature.commitments@unep-wcmc.org',
        url: 'not a link'
      },
      {
        title: 'About',
        url: '#'
      },
      {
        title: 'CBD Action Agenda',
        url: 'https://www.cbd.int/action-agenda/'
      }
    ]
  end
end
