# frozen_string_literal: true

module Peak
  module Env
    module Constants
      # @api public
      APP_NAME_PATTERN = /_application\z/.freeze

      # @api public
      DEFAULT_TARGET = 'development'

      # @api public
      DEFAULT_VALUE = Object.new.freeze

      # @api public
      NAMESPACE_PATTERN = /[_\.]/.freeze
    end
  end
end
