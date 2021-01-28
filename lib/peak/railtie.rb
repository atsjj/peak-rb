# frozen_string_literal: true

require 'dry/core/constants'

module Peak
  class Railtie < ::Rails::Railtie
    include Dry::Core::Constants
    include Peak::Env::Constants

    config.peak = Peak::Configuration.config

    config.eager_load_namespaces << Peak

    initializer 'peak.env', before: :load_environment_hook do |app|
      Peak.config.env.namespace = app.railtie_name.sub(APP_NAME_PATTERN, EMPTY_STRING)
      Peak.config.env.prefix = app.config.peak.env.prefix
      Peak.config.env.target = Rails.env

      Peak::Env.instance = Peak::Env::Resolver.new
    end
  end
end
