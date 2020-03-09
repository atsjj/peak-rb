require 'dry/transformer/registry'

module Peak
  module Transform
    module Coercions
      extend Dry::Transformer::Registry

      class << self
        def to_lowercase(value)
          value.downcase
        end
      end
    end
  end
end
