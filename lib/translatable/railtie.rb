# frozen_string_literal: true

module Translatable
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/translate.rake'
    end
  end
end
