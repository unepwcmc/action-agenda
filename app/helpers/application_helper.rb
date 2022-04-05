module ApplicationHelper
  def nav_header(signed_in)
    navPresenter = NavigationPresenter.new

    navPresenter.nav_header(signed_in)
  end

  def footer_nav
    navPresenter = NavigationPresenter.new

    navPresenter.nav_footer
  end

  def footer_icons; end

  def site_logos
    imagePresenter = ImagePresenter.new

    imagePresenter.site_logos
  end

  def error_messages(resource)
    errorPresenter = ErrorPresenter.new

    errorPresenter.error_messages(resource)
  end
end
