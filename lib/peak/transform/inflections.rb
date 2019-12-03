require 'transproc/registry'

module Peak
  module Transform
    module Inflections
      extend Transproc::Registry

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
