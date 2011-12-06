module TranslationFilter

  def t(input)
    I18n.translate(input)
  end

end

Comatose.register_filter TranslationFilter