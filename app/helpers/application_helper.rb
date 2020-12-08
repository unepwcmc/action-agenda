module ApplicationHelper
  def header_nav
    navPresenter = NavigationPresenter.new
    
    navPresenter.nav_header
  end

  def footer_nav
    navPresenter = NavigationPresenter.new
    
    navPresenter.nav_footer
  end

  def footer_icons
  end
end
