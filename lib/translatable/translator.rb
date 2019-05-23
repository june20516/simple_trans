# frozen_string_literal: true

require 'json'
require_relative './allow_locales'

module Translatable
  class Translator
    attr_reader :record, :locale

    def initialize(record, locale)
      @record = record
      @locale = locale.to_s.to_sym
    end

    def allowed_locales
      ALLOW_LOCALES
    end

    def parse(attr)
      o = original(attr)
      valid_json?(o) ? JSON.parse(o).symbolize_keys : {}
    end

    def valid?(attr)
      valid_translate? original(attr)
    end

    private

    def original(attr)
      record.send(attr)
    end

    def valid_translate?(v)
      return false unless valid_json?(v)

      h = JSON.parse(v).symbolize_keys
      return false if (h.keys & allowed_locales).empty?

      true
    end

    def valid_json?(json)
      JSON.parse(json)
      return true
    rescue JSON::ParserError, TypeError => e
      return false
    end
  end
end
