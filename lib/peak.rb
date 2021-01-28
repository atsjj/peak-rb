# frozen_string_literal: true

require 'active_support'

module Peak
  extend ActiveSupport::Autoload

  autoload :Authentication
  autoload :Configuration
  autoload :Enum
  autoload :Env
  autoload :Function
  autoload :Graph
  autoload :Hash
  autoload :Initializer
  autoload :JsonWebToken
  autoload :VERSION

  class << self
    def config
      Configuration.config
    end
  end
end

require 'peak/railtie' if defined?(Rails)
