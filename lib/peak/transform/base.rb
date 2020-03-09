require 'dry/core/class_attributes'
require 'dry/core/constants'
require 'dry/transformer/array'
require 'dry/transformer/coercions'
require 'dry/transformer/conditional'
require 'dry/transformer/hash'
require 'dry/transformer/recursion'
require 'dry/transformer/registry'

module Peak
  module Transform
    module Base
      extend Dry::Core::ClassAttributes
      extend Dry::Transformer::Registry
      include Dry::Core::Constants

      import Dry::Transformer::ArrayTransformations
      import Dry::Transformer::Coercions
      import Dry::Transformer::Conditional
      import Dry::Transformer::HashTransformations
      import Dry::Transformer::Recursion

      import Coercions
      import Inflections
    end
  end
end
