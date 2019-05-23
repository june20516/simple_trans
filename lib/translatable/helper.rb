# frozen_string_literal: true

require_relative './allow_locales'

def merge_locales_format(*locales)
  ALLOW_LOCALES & locales
end

def sort_locales_inside(locale_hash)
  res = {}
  ALLOW_LOCALES.each { |lo| res[lo] = locale_hash[lo] }
  res
end
