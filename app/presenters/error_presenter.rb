class ErrorPresenter
  def error_messages(resource)
    resource.errors.messages.map do |field, error_messages|
      # convert field from snake case
      recased_field_name = ActiveSupport::Inflector.humanize(field, capitalize: false)

      error_messages.map do |error_message|
        # make error message casing consistent (not default for Devise)
        recased_error_message = error_message.downcase

        "#{recased_field_name} #{recased_error_message}"
      end
    end.flatten
  end
end
