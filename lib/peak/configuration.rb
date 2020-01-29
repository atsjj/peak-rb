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
      setting(:openid) do
        setting(:audience) do
          setting(:whitelist, EMPTY_ARRAY)
        end
      end
    end

    setting(:cache_store, :null_store) do |store|
      if store.is_a?(::Symbol)
        ActiveSupport::Cache.lookup_store(store)
      else
        store
      end
    end

    setting(:logger, ActiveSupport::Logger.new(STDOUT))
  end
end
