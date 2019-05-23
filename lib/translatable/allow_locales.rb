# frozen_string_literal: true

ALLOW_LOCALES ||= ENV.fetch('SIMPLE_TRANS_LOCALES', 'en').split(',').map(&:to_sym).freeze
