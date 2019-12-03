require 'dry/core/class_attributes'
require 'dry/core/constants'
require 'transproc'
require 'transproc/array'
require 'transproc/coercions'
require 'transproc/conditional'
require 'transproc/hash'
require 'transproc/recursion'
require 'transproc/registry'

module Peak
  module Transform
    module Base
      extend Dry::Core::ClassAttributes
      extend Transproc::Registry
      include Dry::Core::Constants

      import Transproc::ArrayTransformations
      import Transproc::Coercions
      import Transproc::Conditional
      import Transproc::HashTransformations
      import Transproc::Recursion

      import Coercions
      import Inflections
    end
  end
end
