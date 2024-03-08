module ApplicationHelper
  def nav_header(signed_in)
    navPresenter = NavigationPresenter.new

    navPresenter.nav_header(signed_in)
  end

  def footer_nav
    navPresenter = NavigationPresenter.new

    navPresenter.nav_footer
  end

  def contact_email
    navPresenter = NavigationPresenter.new

    navPresenter.contact_us
  end

  def footer_icons; end

  def site_logos
    image_presenter = ImagePresenter.new

    image_presenter.site_logos
  end

  def main_logo
    image_presenter = ImagePresenter.new

    image_presenter.main_logo
  end

  def error_messages(resource)
    errorPresenter = ErrorPresenter.new

    errorPresenter.error_messages(resource)
  end
end
