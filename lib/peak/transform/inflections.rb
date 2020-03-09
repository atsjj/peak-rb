require 'dry/transformer/registry'

module Peak
  module Transform
    module Inflections
      extend Dry::Transformer::Registry

      class << self
        def dasherize(value)
          value.dasherize
        end

        def underscore(value)
          value.underscore
        end
      end
    end
  end
end
