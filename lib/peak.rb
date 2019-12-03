require 'active_support'

module Peak
  extend ActiveSupport::Autoload

  autoload :Function
  autoload :Initializer
  autoload :Model
  autoload :Precompile
  autoload :Records
  autoload :Struct
  autoload :Transform
  autoload :Transformer
  autoload :Types
  autoload :VERSION
end
