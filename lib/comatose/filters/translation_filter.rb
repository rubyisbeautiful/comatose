module TranslationFilter

  def t(input)
    Translation.translate(input)
  end

end

Comatose.register_filter TranslationFilter