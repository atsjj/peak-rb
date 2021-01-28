# frozen_string_literal: true

require 'dry/configurable'
require 'dry/core/constants'

module Peak
  class Configuration
    extend Dry::Configurable
    include Dry::Core::Constants

    setting(:authentication) do
      setting(:jwt) do
        setting(:secret_key)
        setting(:algorithms, ['RS256'])
      end
    end
  end
end
