# frozen_string_literal: true

require 'dry/core/constants'

module Peak
  class Railtie < ::Rails::Railtie
    include Dry::Core::Constants
    include Peak::Env::Constants

    config.peak = ActiveSupport::OrderedOptions.new
    config.peak.env.environment = ENV
    config.peak.env.namespace = EMPTY_STRING
    config.peak.env.prefix = EMPTY_STRING
    config.peak.env.target = DEFAULT_TARGET

    config.eager_load_namespaces << Peak

    initializer 'peak.env', before: :load_environment_hook do |app|
      Peak.config.env.environment = app.config.peak.env.environment
      Peak.config.env.namespace = app.railtie_name.sub(APP_NAME_PATTERN, EMPTY_STRING)
      Peak.config.env.prefix = app.config.peak.env.prefix
      Peak.config.env.target = Rails.env

      Peak::Env.instance = Peak::Env::Resolver.new
    end
  end
end
