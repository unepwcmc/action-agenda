class ErrorPresenter
  def error_messages(resource)
    resource.errors.messages.map do |field, error_messages|
      error_messages.map { |error_message| "#{field} #{error_message}" }
    end.flatten
  end
end
