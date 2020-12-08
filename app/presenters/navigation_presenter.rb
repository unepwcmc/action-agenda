class NavigationPresenter
  include Rails.application.routes.url_helpers

  def initialize
  end

  def nav_header
    [
      {
        title: 'Home',
        url: '/'
      },
      {
        title: 'Make a Commitment',
        url: '#'
      },
      {
        title: 'Explore Commitments',
        url: commitments_path
      },
      {
        title: 'About',
        url: '#'
      }
    ]
  end

  def nav_footer 
    [
      {
        title: 'Make a Commitment',
        url: '#'
      },
      {
        title: 'Explore Commitments',
        url: commitments_path
      },
      {
        title: 'About',
        url: '#'
      },
      {
        title: 'Main Action Agenda',
        url: 'https://www.cbd.int/action-agenda/'
      }
    ]
  end
end