# frozen_string_literal: true

module GoogleAnalyticsHelper
  
  def render_google_analytics_tag
    return unless Rails.env.production?

    measurement_id = Rails.application.credentials[Rails.env.to_sym].dig(:google_analytics, :measurement_id)
    %{
      <!-- Google tag (gtag.js) -->

      <script async src="https://www.googletagmanager.com/gtag/js?id=#{measurement_id}"></script>
      <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', '#{measurement_id}');
      </script>
    }.html_safe
  end
end
