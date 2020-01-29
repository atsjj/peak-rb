require 'active_support'

module Peak
  extend ActiveSupport::Autoload

  autoload :Authentication
  autoload :Configuration
  autoload :Function
  autoload :Initializer
  autoload :JsonWebToken
  autoload :Model
  autoload :Precompile
  autoload :Records
  autoload :Struct
  autoload :Transform
  autoload :Transformer
  autoload :Types
  autoload :VERSION

  class << self
    def config
      Configuration.config
    end
  end
end
