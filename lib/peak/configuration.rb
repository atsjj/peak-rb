# frozen_string_literal: true

require 'dry/configurable'
require 'dry/core/constants'

module Peak
  class Configuration
    extend Dry::Configurable
    include Dry::Core::Constants
    include Peak::Env::Constants

    setting(:authentication) do
      setting(:jwt) do
        setting(:secret_key)
        setting(:algorithms, ['RS256'])
      end
    end

    setting(:env) do
      setting(:instance, Peak::Env::Resolver.new)
      setting(:environment, ENV)
      setting(:prefix, EMPTY_STRING)
      setting(:namespace, EMPTY_STRING)
      setting(:target, DEFAULT_TARGET)
    end
  end
end
