# frozen_string_literal: true

require 'dry/core/constants'

module Peak
  class Railtie < ::Rails::Railtie
    include Dry::Core::Constants
    include Peak::Env::Constants

    config.peak = Peak.config

    config.eager_load_namespaces << Peak

    initializer 'peak.env', before: :load_environment_hook do |app|
      Peak.config.env.target = app.env
      Peak.config.env.namespace = app.app_class
        .name
        .constantize
        .railtie_name
        .sub(APP_NAME_PATTERN, EMPTY_STRING)
    end
  end
end
