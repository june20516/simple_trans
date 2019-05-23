# frozen_string_literal: true

require 'rails'

require "active_support"
require "active_support/rails"

require_relative './translatable/allow_locales'
require_relative './translatable/helper'
require_relative './translatable/railtie' if defined?(Rails)

module Translatable
  extend ActiveSupport::Concern

  def include(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def translate_column(name, locales = ALLOW_LOCALES)
      locales = merge_locales_format(*locales)
      make_translator_method(name)
      make_model_method(self, name, locales)
    end
  end

  def translate(locale: I18n.locale)
    @translate = Translator.new(self, locale)
  end
end

require_relative './translatable/translator'
require_relative './translatable/macro_helper'
