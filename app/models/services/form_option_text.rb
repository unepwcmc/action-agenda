class Services::FormOptionText
  def call(name, klass)
    underscore_name = name.downcase.gsub(' ', '_').to_sym
    if I18n.t("models.#{ klass }.additional_form_text").keys.include?(underscore_name.to_sym)
      I18n.t("models.#{ klass }.additional_form_text.#{ underscore_name }")
    else
      name
    end
  end
end