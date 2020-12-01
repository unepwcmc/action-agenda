module ApplicationHelper
  def footer_nav
    navPresenter = NavigationPresenter.new
    
    navPresenter.nav_footer
  end

  def footer_icons
  end
end
