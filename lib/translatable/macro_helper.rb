# frozen_string_literal: true

require_relative './helper'
require_relative './translator'

def make_translator_method(name)
  Translatable::Translator.class_eval <<-CODE, __FILE__, __LINE__ + 1
    def #{name}
      parse(:#{name})[locale]
    end

    def #{name}=(name)
      return unless valid?(:#{name})

      origin = parse(:#{name})
      origin[locale] = name
      record.public_send(:#{name}=, origin)
    end
  CODE
end

def make_model_method(klass, name, locales)
  klass.class_eval <<-CODE, __FILE__, __LINE__ + 1
    def #{name}=(locales = {})
      unless locales.is_a?(Hash)
        errors.add(:#{name}, 'setter should take value of Hash type only. (TypeError)')
        raise ActiveRecord::RecordInvalid.new(self)
      end
      locales = locales.symbolize_keys

      h = translate.parse(:#{name})
      #{locales}.each { |lo| locales[lo] ||= h[lo] }

      super(sort_locales_inside(locales).to_json)
    end
  CODE
end
