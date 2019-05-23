# frozen_string_literal: true

module Translatable
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/simple_trans.rake'
    end
  end
end
