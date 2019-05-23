# frozen_string_literal: true

require 'optparse'
require 'json'
require_relative '../translatable/allow_locales'

namespace :simple_trans do

  desc '[SimpleTrans] Migrate legacy record to translatable column format'
  task migrate: :environment do
    option = listen_option('Usage: rake simple_trans:migrate [options]') do |listeners|
      listeners << [:name, '-m', '--model ModelName', String]
      listeners << [:attribute, '-a', '--attr attribute', String]
    end

    model_name = option[:name].try(:classify)
    raise('Option missing :name / Use -m or --model ModelName') unless option[:name].present?

    attribute_name = option[:attribute]
    raise('Option missing :attribute / Use -a or --attr attribute') unless attribute_name.present?

    model = model_name.try(:constantize)
    raise("'#{model_name}' doesn't have :translate method.") unless model.method_defined? :translate

    model.find_in_batches do |collection|
      collection.each do |record|
        attr = record.public_send(attribute_name.to_sym)
        next unless attr.present? # don't has any source value.
        next if valid_translate?(attr) # already correct.

        value = fixed_attr(attr)
        record.public_send("#{attribute_name}=", value)
        record.save
        puts "(#{model_name} id #{record.id}) migrating #{attribute_name} (from '#{"#{attr}".green}' to < #{"#{value}".green} >)"
      end
    end
  end
end

def fixed_attr(val = '')
  ALLOW_LOCALES.map { |l| [l, val] }.to_h.to_json
end

def valid_translate?(v)
  return false unless valid_json?(v)

  h = JSON.parse(v).symbolize_keys
  return false if (h.keys & ALLOW_LOCALES).empty?

  true
end

def valid_json?(json)
  JSON.parse(json)
  return true
rescue JSON::ParserError => e
  return false
end

def listen_option(banner, option = {})
  o = OptionParser.new
  o.banner = banner
  rules = block_given? ? yield([]) : []
  rules.each do |rule|
    key = rule.shift.to_s.to_sym
    o.on(*rule) { |v| option[key] = v.gsub(/=/, '').strip }
  end

  args = o.order!(ARGV) {}
  o.parse! args

  option
end
